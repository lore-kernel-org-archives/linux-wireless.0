Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:57745 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965236Ab3DQPnC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Apr 2013 11:43:02 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1USUVh-00085g-6w
	for linux-wireless@vger.kernel.org; Wed, 17 Apr 2013 17:43:01 +0200
Received: from 69-165-152-163.dsl.teksavvy.com ([69.165.152.163])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Wed, 17 Apr 2013 17:43:01 +0200
Received: from JoelleEmmily by 69-165-152-163.dsl.teksavvy.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Wed, 17 Apr 2013 17:43:01 +0200
To: linux-wireless@vger.kernel.org
From: Joelle <JoelleEmmily@gmail.com>
Subject: Re: RTL8187 in master mode with hostapd
Date: Wed, 17 Apr 2013 15:42:47 +0000 (UTC)
Message-ID: <loom.20130417T174126-534@post.gmane.org> (sfid-20130417_174307_227938_F2E4CA83)
References: <20120727171137.4a1d1ce7@homerow> <501405FA.3070504@lwfinger.net> <20120728211613.45ca10fa@homerow> <5016A5D3.10301@lwfinger.net> <loom.20130417T144556-632@post.gmane.org> <516EB581.9080602@lwfinger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> I did not say that the RTL8187{B,L} cannot be used as an AP! I said that
rtl8187 
> cannot. The capitalization is important. With caps, it refers to a device; 
> without implies a driver.
> 
> I am not sure how well an RTL8187L would work as it only has a single
transmit 
> queue, but perhaps it would work.
> 
> If you think there is a "crime against technology", then you need to be
the one 
> to make the necessary changes to rtl8187. After all, the source is open.
> 
> Larry
> 

The driver as distributed with the distros cannot provided AP functionality,
this is true. However one only needs to patch in the proper call functions
for AP functionality to work, which is what I did with the power functions.
The patch is available on the Realtek site but is formatted for kernal ver
2.something and thus most be painstakingly edited in. This means that the
driver as provided by the manufacturer, which was also provided as open
source, utilized these functions and more. But as this chipset is now
considered legacy by the manufacturer they no longer update the driver, thus
breaking compatibility with new generations of linux.

I see this as a "crime against technology", and the comment that
compatibility will 'never' come because the ability is and was available in
these prior versions, all be it patched. This means that very little work
needs to be done by someone who knows what they are doing. As for myself, I
only 'almost' know what I'm doing and can't provide the technical expertise
required to build a reliable enough driver to be given to the distros, nor
do I have the repute to suggest an integration.

It's also a crime that the windows drivers continue to be updated, at the
least a newish win 7 is available, but the linux community does not wish to
peruse greater functionality. While I can't substantiate this with any
degree of certainty I do recall an Ubuntu mod saying that they will never
provider greater support because the primary use for the Alfa adapters,
which was the primary purchaser of said chipsets, is for hacking purposes.
This is a tragedy as the rtl8187, or any in that series, as well as the Alfa
adapters can and do provide an excellent platform for many wifi needs.

I also should address the transmit issue as well if I'm to maintain any
credibility. High priority kernal patches can be used to provide one's
software router with appropriate timing. In fact there were, perhaps are, a
lot of 'very cheep' wifi router which had limited capabilities in their
chipsets but made up for those deficiencies with software 'cheats'. At this
moment I'm serving my 'very' small town with free wifi internet through a
Windows XP Aspire One, with routing provided by my dedicated linux soft
router. Despite the slowness of the laptop, idiocies of windows, and other
drawbacks with my setup I've had up to 30 people surfing at once with a peek
of 50 or so sitting authenticated.

It's a shame I can't integrate my soft-router and my soft-AP into one unit
without having to downgrade to an earlier release or having an aneurysm
because I'm staring at code during my few free time hours.

