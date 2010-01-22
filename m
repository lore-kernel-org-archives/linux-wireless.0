Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f190.google.com ([209.85.222.190]:39058 "EHLO
	mail-pz0-f190.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751932Ab0AVTx0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Jan 2010 14:53:26 -0500
Received: by pzk28 with SMTP id 28so325404pzk.4
        for <linux-wireless@vger.kernel.org>; Fri, 22 Jan 2010 11:53:25 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4B59FC5E.1020802@redfish-solutions.com>
References: <Pine.LNX.4.64.0912261245080.5112@cheetah.psv.nu>
	<20091229020027.GE30201@bombadil.infradead.org> <4B59FC5E.1020802@redfish-solutions.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Fri, 22 Jan 2010 11:53:05 -0800
Message-ID: <43e72e891001221153w5c4c4bc6g63883b5012d384b7@mail.gmail.com>
Subject: Re: Compat-wireless bleeding-edge daily builds broken since
	2009-12-11
To: "Philip A. Prindeville" <philipp_subx@redfish-solutions.com>
Cc: "Luis R. Rodriguez" <mcgrof@bombadil.infradead.org>,
	Peter Svensson <petersv@psv.nu>, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jan 22, 2010 at 11:28 AM, Philip A. Prindeville
<philipp_subx@redfish-solutions.com> wrote:
> On 12/28/2009 06:00 PM, Luis R. Rodriguez wrote:
>> On Sat, Dec 26, 2009 at 12:50:23PM +0100, Peter Svensson wrote:
>>
>>> Hi,
>>>
>>> The bleeding edge nightly snapshopts in
>>>   http://wireless.kernel.org/download/compat-wireless-2.6/
>>> are not updated since the compat-bluetooth were introduced (I think) on
>>> 2009-12-11.
>>>
>>> When built from the git sources the driver works very nicely, and much
>>> more stable than the last drop on 2009-12-11.
>>>
>> This will be fixed soon, just need to re-instate access to the box.
>>
>>   Luis
>>
>
>
> Is this the issue I'm seeing?  Has it been fixed yet?

Well so I now have access to the box but the box got a face lift and
during that time I didn't want to clone linux-next on it. While all
that happened in the background I just started making bleeding edge
compat-wireless releases on orbit-lab.org along with updating the
symlink to point to the latest dated release.

wireless.kernel.org upgrade has now completed but I think I prefer to
continue doing the bleeding edge compat-wireless updates on
orbit-lab.org as I have full access there and can soon start doing
compile tests for each kernel as I have unlimited disk space (or so I
like to believe). I see it useful to still have the bleeding edge
tarball on wireless.kernel.org though due to the URL name, etc, but I
can just scp it over. I haven't gotten to that yet.

For now use:

http://www.orbit-lab.org/kernel/compat-wireless-2.6/compat-wireless-2.6.tar.bz2

for bleeding edge

Seems my cronjobs aren't kicking off yet, will debug that today too.

  Luis
