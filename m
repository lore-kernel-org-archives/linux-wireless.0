Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f179.google.com ([209.85.214.179]:36690 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751459AbbEGPnG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 May 2015 11:43:06 -0400
Received: by obbkp3 with SMTP id kp3so34425645obb.3
        for <linux-wireless@vger.kernel.org>; Thu, 07 May 2015 08:43:05 -0700 (PDT)
Message-ID: <554B8807.4000302@lwfinger.net> (sfid-20150507_174311_273670_4D83A1BF)
Date: Thu, 07 May 2015 10:43:03 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	Jes Sorensen <Jes.Sorensen@redhat.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 1/1] New driver: rtl8723au (mac80211)
References: <55492249.2070900@gmail.com> <wrfj1tiu3dq8.fsf@ultrasam.lan.trained-monkey.org> <554B33C1.2090304@gmail.com>
In-Reply-To: <554B33C1.2090304@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/07/2015 04:43 AM, Xose Vazquez Perez wrote:
> On 05/05/2015 11:40 PM, Jes Sorensen wrote:
>
>> As I posted elsewhere, I intend to add support for other rtl8xxx
>> USB chips, hence the 8xxx name.
>
> How many kinds of chips will support ?

The potential list of USB chips includes RTL8192DU, RTL8723BU, RTL8812AU, and 
RTL8188EU. In addition, the SDIO chips RTL8723AS and RTL8723BS might fit under 
this umbrella.

Larry


