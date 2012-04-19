Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:60181 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751567Ab2DSOZO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Apr 2012 10:25:14 -0400
Message-ID: <4F90204D.3060801@sipsolutions.net> (sfid-20120419_162518_791232_FF0A5293)
Date: Thu, 19 Apr 2012 07:25:17 -0700
From: Johannes Berg <johannes@sipsolutions.net>
MIME-Version: 1.0
To: Tino Keitel <tino.keitel@tikei.de>
CC: linux-wireless@vger.kernel.org
Subject: Re: Power saving features for iwl4965
References: <20120418203543.GA16000@x61.home> (sfid-20120418_224526_110569_61770156)
In-Reply-To: <20120418203543.GA16000@x61.home> (sfid-20120418_224526_110569_61770156)
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 4/18/2012 1:35 PM, Tino Keitel wrote:
> up to 2.6.38, the iwl4965 driver was able to use power saving features
> by invoking "iwconfig<interface>  power on", at least when unsetting
> the broken_powersave variable.

This isn't quite correct. Yes, power saving was enabled there, but 
relatively frequently it caused the device to crash. Therefore, it was 
disabled as a stability fix, not to remove powersaving from you :)

johannes
