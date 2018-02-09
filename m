Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx4.wp.pl ([212.77.101.11]:54557 "EHLO mx4.wp.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752362AbeBIR5S (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 9 Feb 2018 12:57:18 -0500
Date: Fri, 9 Feb 2018 09:57:12 -0800
From: Jakub Kicinski <kubakici@wp.pl>
To: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 0/2] mt7601u: update mac addr if different from eeprom
 one
Message-ID: <20180209095712.2113cb4e@cakuba.netronome.com> (sfid-20180209_190711_663679_E6FB727E)
In-Reply-To: <cover.1518126991.git.lorenzo.bianconi@redhat.com>
References: <cover.1518126991.git.lorenzo.bianconi@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu,  8 Feb 2018 23:08:07 +0100, Lorenzo Bianconi wrote:
> Lorenzo Bianconi (2):
>   mt7601u: move mt7601u_set_macaddr in mac related code
>   mt7601u: set device mac address in mt7601u_add_interface()
> 
>  drivers/net/wireless/mediatek/mt7601u/eeprom.c | 24 ++----------------------
>  drivers/net/wireless/mediatek/mt7601u/mac.c    | 16 ++++++++++++++++
>  drivers/net/wireless/mediatek/mt7601u/mac.h    |  1 +
>  drivers/net/wireless/mediatek/mt7601u/main.c   |  3 +++
>  4 files changed, 22 insertions(+), 22 deletions(-)
> 

Acked-by: Jakub Kicinski <kubakici@wp.pl>
