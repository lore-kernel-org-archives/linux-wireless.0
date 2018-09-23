Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:41744 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726088AbeIWU6S (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 23 Sep 2018 16:58:18 -0400
Subject: Re: [PATCH 0/9] unify tx power eeprom parsing for mt76x{0,2}
To: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc: linux-wireless@vger.kernel.org
References: <20180922114537.24004-1-lorenzo.bianconi@redhat.com>
From: Felix Fietkau <nbd@nbd.name>
Message-ID: <363fac97-7991-dc19-a3a4-c40212fc7688@nbd.name> (sfid-20180923_170036_335585_7DBDC089)
Date: Sun, 23 Sep 2018 17:00:31 +0200
MIME-Version: 1.0
In-Reply-To: <20180922114537.24004-1-lorenzo.bianconi@redhat.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2018-09-22 13:45, Lorenzo Bianconi wrote:
> This is the second of two series that unify eeprom code between
> mt76x2 and mt76x0 drivers. In particular this series unifies
> tx power eeprom parsing. That patchset will be used to properly
> support mt76x0e chipsets without duplicating the code.
> 
> Lorenzo Bianconi (9):
>   mt76: move mt76_rate_power in mt76_dev
>   mt76: add mt76x02_phy_set_txpower utility routine
>   mt76: move rate_txpower handler in mt76 debugfs
>   mt76: move mt76x02_rate_power_val in mt76x02-lib module
>   mt76x0: remove mt76x0_phy_set_tx_power and mt76x0_extra_power_over_mac
>   mt76x0: remove eeprom dependency from mt76x0_set_tx_power_per_rate
>   mt76x0: remove eeprom dependency from mt76x0_get_power_info
>   mt76x0: use shared debugfs implementation
>   mt76x0: phy: introduce mt76x0_phy_set_txpower routine
Merged, thanks.

- Felix
