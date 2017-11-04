Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:18525 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750709AbdKDGUc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 4 Nov 2017 02:20:32 -0400
Date: Sat, 4 Nov 2017 09:20:18 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Aditya Shankar <aditya.shankar@microchip.com>
Cc: linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
        ganesh.krishna@microchip.com, stable@vger.kernel.org,
        gregkh@linuxfoundation.org
Subject: Re: [PATCH] staging: wilc1000: Fix bssid buffer offset in Txq
Message-ID: <20171104062018.afsgkmosxjeojoi3@mwanda> (sfid-20171104_072038_439707_8B883C00)
References: <1509699387-6916-1-git-send-email-aditya.shankar@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1509699387-6916-1-git-send-email-aditya.shankar@microchip.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This driver really needs proper structs and datatypes so this doesn't
happen again and so that you and Colin stop reverting each other's

	*pu8CurrByte++ = ((strHostIfSetMulti->enabled >> 8) & 0xFF);

assignments:

regards,
dan carpenter
