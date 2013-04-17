Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qc0-f173.google.com ([209.85.216.173]:61909 "EHLO
	mail-qc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752314Ab3DQQa4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Apr 2013 12:30:56 -0400
Received: by mail-qc0-f173.google.com with SMTP id b12so796390qca.4
        for <linux-wireless@vger.kernel.org>; Wed, 17 Apr 2013 09:30:55 -0700 (PDT)
Message-ID: <516ECE3D.2090003@lwfinger.net> (sfid-20130417_183107_499092_3470EB19)
Date: Wed, 17 Apr 2013 11:30:53 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Joelle <JoelleEmmily@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: RTL8187 in master mode with hostapd
References: <20120727171137.4a1d1ce7@homerow> <501405FA.3070504@lwfinger.net> <20120728211613.45ca10fa@homerow> <5016A5D3.10301@lwfinger.net> <loom.20130417T144556-632@post.gmane.org> <516EB581.9080602@lwfinger.net> <loom.20130417T174126-534@post.gmane.org>
In-Reply-To: <loom.20130417T174126-534@post.gmane.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/17/2013 10:42 AM, Joelle wrote:
>
> The driver as distributed with the distros cannot provided AP functionality,
> this is true. However one only needs to patch in the proper call functions
> for AP functionality to work, which is what I did with the power functions.
> The patch is available on the Realtek site but is formatted for kernal ver
> 2.something and thus most be painstakingly edited in. This means that the
> driver as provided by the manufacturer, which was also provided as open
> source, utilized these functions and more. But as this chipset is now
> considered legacy by the manufacturer they no longer update the driver, thus
> breaking compatibility with new generations of linux.

Again, you are mixing apples and oranges. The driver on the Realtek web site 
does not use mac80211; whereas the one in the kernel does.

> I see this as a "crime against technology", and the comment that
> compatibility will 'never' come because the ability is and was available in
> these prior versions, all be it patched. This means that very little work
> needs to be done by someone who knows what they are doing. As for myself, I
> only 'almost' know what I'm doing and can't provide the technical expertise
> required to build a reliable enough driver to be given to the distros, nor
> do I have the repute to suggest an integration.

If you do not have the skills to integrate the changes, then you need to find 
someone that can. I must say that accusing peoples of "crimes against 
technology" is hardly tghe way to start.

> It's also a crime that the windows drivers continue to be updated, at the
> least a newish win 7 is available, but the linux community does not wish to
> peruse greater functionality. While I can't substantiate this with any
> degree of certainty I do recall an Ubuntu mod saying that they will never
> provider greater support because the primary use for the Alfa adapters,
> which was the primary purchaser of said chipsets, is for hacking purposes.
> This is a tragedy as the rtl8187, or any in that series, as well as the Alfa
> adapters can and do provide an excellent platform for many wifi needs.

If the Ubuntu quote was referring to using the driver with air-crack, then I agree.

> I also should address the transmit issue as well if I'm to maintain any
> credibility. High priority kernal patches can be used to provide one's
> software router with appropriate timing. In fact there were, perhaps are, a
> lot of 'very cheep' wifi router which had limited capabilities in their
> chipsets but made up for those deficiencies with software 'cheats'. At this
> moment I'm serving my 'very' small town with free wifi internet through a
> Windows XP Aspire One, with routing provided by my dedicated linux soft
> router. Despite the slowness of the laptop, idiocies of windows, and other
> drawbacks with my setup I've had up to 30 people surfing at once with a peek
> of 50 or so sitting authenticated.

If you have the ability to setup and maintain something like that, then I would 
think you should be able to port the non-mac80211 driver to modern kernels, or 
modify the kernel driver. At the moment, I am working on 3 drivers for which 
there is *NO* Linux driver publicly available. To me, that has a much higher 
priority. Besides, I am not getting paid to do this, and you are making me want 
to go fishing.

Larry

