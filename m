Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.238]:50666 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752374AbYHTUt4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Aug 2008 16:49:56 -0400
Received: by rv-out-0506.google.com with SMTP id k40so627763rvb.1
        for <linux-wireless@vger.kernel.org>; Wed, 20 Aug 2008 13:49:56 -0700 (PDT)
Message-ID: <48AC836B.2020207@gmail.com> (sfid-20080820_225002_112959_7EFB2137)
Date: Wed, 20 Aug 2008 21:49:47 +0100
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless@vger.kernel.org, proski@gnu.org,
	orinoco-devel@lists.sourceforge.net
Subject: Re: [PATCH 00/19] orinoco: WPA for Agere based cards
References: <1217672073-7094-1-git-send-email-kilroyd@gmail.com> <20080820192812.GA1746@tuxdriver.com>
In-Reply-To: <20080820192812.GA1746@tuxdriver.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
From: Dave <kilroyd@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John W. Linville wrote:
> On Sat, Aug 02, 2008 at 11:14:14AM +0100, kilroyd@googlemail.com wrote:
>> This patch series enables WPA on Agere based orinoco devices.
>>
>> Patchset overview
>> 1-2: General scanning updates
>> 3-9: Agere firmware download to RAM
>> 10-12: Update orinoco to work with new firmware
>> 13-19: WPA functionality
>>
>> This patchset is against wireless-testing (master-2008-07-16), is
>> sparse clean (UP), and should be bisectable. It is almost checkpatch
>> clean - the single warning looks like a false positive to me.
> 
> Are we satisfied w/ this patch series?  If so, could I ask Dave to
> repost them as a single series (rather than having to randomly replace
> some of them) in the middle?

I believe I have addressed all the issues that I can. The main outstanding one is why Pavel was seeing issues on his 64 bit kernel/64 bit userspace setup.

I will repost the full series shortly.
 
>> To use WPA, you will need an Agere firmware image. You can get the
>> necessary file at
>> <http://marc.info/?l=orinoco-devel&m=121078835610877>, just extract
>> and rename orinoco.fw to agere_sta_fw.bin and place it in
>> /lib/firmware (or distro equivalent). Alternatively you can try
>> extract firmware from a Windows driver using the program in
>> <http://marc.info/?l=orinoco-devel&m=120846933719051>.
> 
> Is the above documented anywhere other than this email thread?

At the moment this is only documented in email threads (on orinoco-devel) - I lack access to any web/file hosting to put something more permanent up. This obviously ought to be corrected.


Regards,

Dave.
