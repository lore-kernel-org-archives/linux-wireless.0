Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:62075 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751653Ab1AEV04 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Jan 2011 16:26:56 -0500
Received: by iwn9 with SMTP id 9so15664523iwn.19
        for <linux-wireless@vger.kernel.org>; Wed, 05 Jan 2011 13:26:56 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20110105183018.GA2725@tuxdriver.com>
References: <1292864555-28661-1-git-send-email-lrodriguez@atheros.com>
 <20110104184928.GA13239@tuxdriver.com> <20110105182838.GC10391@tux> <20110105183018.GA2725@tuxdriver.com>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Wed, 5 Jan 2011 13:26:36 -0800
Message-ID: <AANLkTikjVWerrdbwXZfoWmaXcq7QTnhn5J-eqWppcqPH@mail.gmail.com>
Subject: Re: [PATCH 0/8] wireless: DFS region support
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Luis Rodriguez <Luis.Rodriguez@atheros.com>,
	Kathy Giori <Kathy.Giori@atheros.com>,
	Amod Bodas <Amod.Bodas@atheros.com>,
	David Quan <David.Quan@atheros.com>,
	Michael Green <Michael.Green@atheros.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jan 5, 2011 at 10:30 AM, John W. Linville
<linville@tuxdriver.com> wrote:
> On Wed, Jan 05, 2011 at 10:28:38AM -0800, Luis R. Rodriguez wrote:
>> On Tue, Jan 04, 2011 at 10:49:28AM -0800, John W. Linville wrote:
>> > On Mon, Dec 20, 2010 at 12:02:26PM -0500, Luis R. Rodriguez wrote:
>> > > This series has a list of changes to kernel and userspace to start addressing
>> > > DFS region support. I've cheated and figured out a way to alter the current
>> > > regulatory database in such a way that it remains backwards compatible with
>> > > older databases so that no new CRDAs are required and we don't have to provide
>> > > two releases for old kernels and newer kernels for wireless-regdb updates.
>> > >
>> > > In the end we end up passing the DFS region to the drivers. In terms of our DFS
>> > > development roadmap this covers parts I and II as promissed that I would take care
>> > > of by tomorrow, and leaves open now the chance for developers to start working
>> > > on part III: "Where do we stuff DFS parameters for each region":
>> > >
>> > > http://wireless.kernel.org/en/developers/DFS
>> > >
>> > > In tomorrow's meeting we can cover who is going to work on part III. People who
>> > > want to work on part III can start using these patches on their systems.
>> > >
>> > > John, lets wait to merge these until Wednesday, I post these in patch form as I
>> > > think they are ready but tomorrow's discussions may push us to alter this a
>> > > bit, not sure. I will also review what we have done here with Michael Green so
>> > > he is on the same page.
>> >
>> > Well, now there has been plenty of time to reflect...comments? :-)
>>
>> I'll reduce the number of bits to 8 instead of 16 for the DFS regions, I'll also
>> try to schedule a call with Michael to finalize his review on this and then I'll
>> respin and submit again.
>
> Well, since Linus released 2.6.37 yesterday there is now no great hurry...

OK thanks for the heads up.

  Luis
