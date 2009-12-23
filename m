Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f171.google.com ([209.85.223.171]:43743 "EHLO
	mail-iw0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756529AbZLWRdx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Dec 2009 12:33:53 -0500
Received: by iwn1 with SMTP id 1so5264057iwn.33
        for <linux-wireless@vger.kernel.org>; Wed, 23 Dec 2009 09:33:52 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1261589400.7538.4.camel@mj>
References: <bfff2faa0912190727jc7fa067gf46425d1cd443698@mail.gmail.com>
	<bfff2faa0912230911w15966e9sbfbba9bd303d3314@mail.gmail.com>
	<1261589400.7538.4.camel@mj>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Wed, 23 Dec 2009 09:33:32 -0800
Message-ID: <43e72e890912230933h3eac574ya7b6b359a32524cb@mail.gmail.com>
Subject: Re: modprobe fail and subsequent crash on rmmod ath9k D-Link DWA 652
To: Pavel Roskin <proski@gnu.org>
Cc: Russ Adams <russ.adams@gmail.com>, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Dec 23, 2009 at 9:30 AM, Pavel Roskin <proski@gnu.org> wrote:
> On Wed, 2009-12-23 at 12:11 -0500, Russ Adams wrote:
>> Nothing new on this just yet.
>>
>> Tonight I will try 2.6.32-2 to see if that fixes the problem.  Does
>> anyone have any debugging steps I can try?
>
> Remember, I asked you to show the debug messages after the ath9k module
> is loaded.  If it's loaded on startup, you can blacklist it and then
> load manually with modprobe.
>
> It seems to me that something fails during the initialization, which
> causes a crash at the unload time.  But since ath9k is working properly
> for most of us, it's hard to figure out what is failing and how to model
> the problem on functioning hardware.

Also, please see:

http://wireless.kernel.org/en/users/Documentation/Reporting_bugs

specifically the parts about the latest stable kernels.

 Luis
