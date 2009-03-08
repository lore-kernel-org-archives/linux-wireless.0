Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:58475 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752044AbZCHO3I (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Mar 2009 10:29:08 -0400
Message-ID: <49B3D62F.4090700@lwfinger.net> (sfid-20090308_152910_353639_19B8D4E2)
Date: Sun, 08 Mar 2009 09:29:03 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: David Thornton <david@villagepublishing.com.au>
CC: linux-wireless@vger.kernel.org
Subject: Re: BCM 4325
References: <264AFFC7-5AF2-42A5-8BB8-1DEDB0255CA9@villagepublishing.com.au>
In-Reply-To: <264AFFC7-5AF2-42A5-8BB8-1DEDB0255CA9@villagepublishing.com.au>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

David Thornton wrote:
> does anyone have any info (documents, datasheet) on the bcm4325 becuase
> i would like to make a driver for it (the fm radio side of things)

What exactly is a BCM4325? It is covered by the Broadcom driver that we are
currently reverse engineering. I guessed that it was a N PHY based on the
number, but your comment would indicate a different kind of radio.

We have no datasheets for any Broadcom wireless device.

Larry
