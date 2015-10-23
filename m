Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:33148 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751274AbbJWPID (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Oct 2015 11:08:03 -0400
Received: by wijp11 with SMTP id p11so81784919wij.0
        for <linux-wireless@vger.kernel.org>; Fri, 23 Oct 2015 08:08:02 -0700 (PDT)
To: linux-wireless <linux-wireless@vger.kernel.org>,
	Pontus Fuchs <pontus.fuchs@gmail.com>
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: ar5523: duplicate ID
Message-ID: <562A4D4F.6000508@gmail.com> (sfid-20151023_170811_496095_3D741B19)
Date: Fri, 23 Oct 2015 17:07:59 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

This device is duplicate at ar5523.c:
        AR5523_DEVICE_UG(0x157e, 0x3006),       /* Umedia / AR5523_1 */
        AR5523_DEVICE_UG(0x157e, 0x3006),       /* Umedia / TEW444UBEU */
