Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:53498 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387453AbeITSX3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 20 Sep 2018 14:23:29 -0400
Subject: Re: [PATCH 00/20] unify mt76x2 and mt76x0 eeprom code
To: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc: linux-wireless@vger.kernel.org, sgruszka@redhat.com,
        linux-mediatek@lists.infradead.org
References: <cover.1537433365.git.lorenzo.bianconi@redhat.com>
From: Felix Fietkau <nbd@nbd.name>
Message-ID: <2589a3bd-85f8-ac73-9818-16020bb560ae@nbd.name> (sfid-20180920_144014_378878_7E7BF038)
Date: Thu, 20 Sep 2018 14:40:07 +0200
MIME-Version: 1.0
In-Reply-To: <cover.1537433365.git.lorenzo.bianconi@redhat.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2018-09-20 11:11, Lorenzo Bianconi wrote:
> This series unify most of eeprom parsing between mt76x2 and
> mt76x0 driver. That patchset will be used to properly support
> mt76x0e chipsets without duplicating the code.
Merged patches 1-17. Transmit power handling will be unified in a
different way.

- Felix
