Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.210.202]:51241 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753974AbZGUX0Z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Jul 2009 19:26:25 -0400
Received: by yxe40 with SMTP id 40so859375yxe.33
        for <linux-wireless@vger.kernel.org>; Tue, 21 Jul 2009 16:26:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <43e72e890907201247x7df76b75wf6ba2bc2260dbf7a@mail.gmail.com>
References: <4A612514.4050708@redfish-solutions.com> <b6c5339f0907190638jc1bdacbo801adcd39a1cf5@mail.gmail.com>
	<4A635E04.4050204@redfish-solutions.com> <20090719203150.GA9972@hash.localnet>
	<4A63DF0B.4010801@redfish-solutions.com> <20090720115244.GC9972@hash.localnet>
	<4A64C283.6090205@redfish-solutions.com> <43e72e890907201247x7df76b75wf6ba2bc2260dbf7a@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Tue, 21 Jul 2009 16:26:05 -0700
Message-ID: <43e72e890907211626y5d4dff08m2c10669636d00044@mail.gmail.com>
Subject: Re: Using compat-wireless w/ 2.6.27.26
To: "Philip A. Prindeville" <philipp_subx@redfish-solutions.com>
Cc: Bob Copeland <me@bobcopeland.com>, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jul 20, 2009 at 12:47 PM, Luis R. Rodriguez<mcgrof@gmail.com> wrote:
> On Mon, Jul 20, 2009 at 12:16 PM, Philip A.
> Prindeville<philipp_subx@redfish-solutions.com> wrote:
>> Bob Copeland wrote:
>>> On Sun, Jul 19, 2009 at 08:05:47PM -0700, Philip A. Prindeville wrote:
>>>> Actually, it's saying:
>>>>
>>>> filename:       /lib/modules/2.6.27.26-astlinux/kernel/drivers/net/wireless/ath5k/ath5k.ko
>>>> depends:        mac80211,cfg80211
>>>>
>>>> And the 0.6.0 version number matches ath5k/base.c in the compat-wireless
>>>> sources as well.
>>>
>>> Yeah, ignore the module version number, no one ever changes it.
>>>
>>>> Not seeing the dependency on "ath", which is strange.  Is that common code
>>>> that's shared in 2.6.30 for the Atheros drivers?
>>>
>>> In 2.6.31, yes.
>>>
>>>>> The fix was merged after 2.6.30, IIRC, but it should definitely be in
>>>>> compat-wireless.  Also check your modules directory for an old ath5k.ko
>>>>> sitting in drivers/.../wireless/ath5k.  It should now be in ath/ath5k.
>>>
>>> See above, the fix was post-2.6.30, however compat-wireless should have
>>> it.  The module should now be in drivers/net/wireless/ath/ath5k, not
>>> drivers/net/wireless/ath5k.
>>>
>>
>> I'm using the tarball out of:
>>
>> http://www.orbit-lab.org/kernel/compat-wireless-2.6-stable/v2.6.30
>>
>> perhaps I should be using a different one?  I tried 2.6.31-rc1, but it doesn't build against 2.6.27.
>
> I have to fix this, will do so in a bit, will also update it to
> account for the new rc3.

Updated:

http://www.orbit-lab.org/kernel/compat-wireless-2.6-stable/v2.6.31/compat-wireless-2.6.31-rc3.tar.bz2

  Luis
