Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3.wp.pl ([212.77.101.10]:14997 "EHLO mx3.wp.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933624AbeB1Tqz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 28 Feb 2018 14:46:55 -0500
Date: Wed, 28 Feb 2018 11:46:47 -0800
From: Jakub Kicinski <kubakici@wp.pl>
To: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mt7601u: remove a warning in
 mt7601u_efuse_physical_size_check()
Message-ID: <20180228114647.37a2de7c@cakuba.netronome.com> (sfid-20180228_204659_092032_8B883AC2)
In-Reply-To: <2850551da4495924bde846dd237b736e41913d0f.1519827461.git.lorenzo.bianconi@redhat.com>
References: <cover.1519827461.git.lorenzo.bianconi@redhat.com>
        <2850551da4495924bde846dd237b736e41913d0f.1519827461.git.lorenzo.bianconi@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 28 Feb 2018 15:26:57 +0100, Lorenzo Bianconi wrote:
> Fix the following sparse warning in mt7601u_efuse_physical_size_check:
> - drivers/net/wireless/mediatek/mt7601u/eeprom.c:77:27: warning:
>   Variable length array is used
> 
> Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>

Acked-by: Jakub Kicinski <kubakici@wp.pl>

Thanks Lorenzo!
