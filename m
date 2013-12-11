Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:31751 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750943Ab3LKJCX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Dec 2013 04:02:23 -0500
Message-ID: <52A82A1D.80409@broadcom.com> (sfid-20131211_100234_527318_2F0CD48C)
Date: Wed, 11 Dec 2013 10:02:21 +0100
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: Jouni Malinen <j@w1.fi>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: wpa_supplicant and driver reload
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Jouni,

A basic questionIn my testing I normally stop wpa_supplicant when 
reloading my driver and start it again, but I was wondering whether this 
is needed. Can wpa_supplicant deal with interface index change for the 
network interface?

Gr. AvS
