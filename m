Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:1895 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932513Ab2JUTgK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 21 Oct 2012 15:36:10 -0400
Message-ID: <50844E9D.2000600@broadcom.com> (sfid-20121021_213614_882978_AD7C7829)
Date: Sun, 21 Oct 2012 21:35:57 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Vladimir Kondratiev" <qca_vkondrat@qca.qualcomm.com>
cc: "John W . Linville" <linville@tuxdriver.com>,
	"Johannes Berg" <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org,
	"Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>
Subject: Re: [PATCH v1 0/2] driver for 60g Wilocity chip wil6210
References: <1350824571-22554-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
In-Reply-To: <1350824571-22554-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/21/2012 03:02 PM, Vladimir Kondratiev wrote:
> Resending driver patches with few corrections:
> - removed piece of unused code
> - removed endianness conversion - it is not integrated and all
> chances it is just wrong. Hardware is little endian, and only platform
> I have is 64-bit Intel.

You could restrict Kconfig to avoid use on big-endian platforms although 
I guess not much people are having this piece of hardware ;-)

Gr. AvS

