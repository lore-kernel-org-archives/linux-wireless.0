Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx4.wp.pl ([212.77.101.11]:20237 "EHLO mx4.wp.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754441AbeCGSSV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 7 Mar 2018 13:18:21 -0500
Date: Wed, 7 Mar 2018 10:18:13 -0800
From: Jakub Kicinski <kubakici@wp.pl>
To: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mt7601u: simplify mt7601u_mcu_msg_alloc signature
Message-ID: <20180307101813.43ede1b9@cakuba.netronome.com> (sfid-20180307_191825_615334_EA6CBC06)
In-Reply-To: <bfc6bf9aa8dc2fe89ad283c457030797d75ec3b8.1520414446.git.lorenzo.bianconi@redhat.com>
References: <cover.1520414446.git.lorenzo.bianconi@redhat.com>
        <bfc6bf9aa8dc2fe89ad283c457030797d75ec3b8.1520414446.git.lorenzo.bianconi@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed,  7 Mar 2018 10:25:50 +0100, Lorenzo Bianconi wrote:
> Remove mt7601u_dev parameter from mt7601u_mcu_msg_alloc signature since
> dev pointer is never used in routine body
> 
> Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>

Acked-by: Jakub Kicinski <kubakici@wp.pl>
