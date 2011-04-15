Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:56212 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756236Ab1DOSGk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Apr 2011 14:06:40 -0400
To: Dennis Borgmann <dennis.borgmann@googlemail.com>
Subject: Re: [iw, ath5k] setting of antennas
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8;
 format=flowed
Date: Fri, 15 Apr 2011 20:06:38 +0200
From: Johannes Berg <johannes@sipsolutions.net>
Cc: <linux-wireless@vger.kernel.org>
In-Reply-To: <4DA87DFA.1020908@googlemail.com>
References: <4DA87DFA.1020908@googlemail.com>
Message-ID: <5ae8577fdd0c6fe123ca737400f1ad2a@secure.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

 On Fri, 15 Apr 2011 19:18:50 +0200, Dennis Borgmann wrote:
> Is it only possible to set the bitmap of used antennas via iw(8) like 
> this:
>
> phy <phyname> set antenna <bitmap> | all | <tx bitmap> <rx bitmap>
>
> Or is there a way to this with an IOCTL or similar in an own program?
>
> I do also know of the (deprecated) way to this via debugfs, but I'd
> really like to do it on my own in a C-program as part of other things 
> to
> be done.

 iw is a C program too ...........

 johannes
