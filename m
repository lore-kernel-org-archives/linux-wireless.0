Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:52132 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757079AbcIOOBL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 15 Sep 2016 10:01:11 -0400
Date: Thu, 15 Sep 2016 10:01:09 -0400
From: Kyle McMartin <kyle@infradead.org>
To: Arend Van Spriel <arend.vanspriel@broadcom.com>
Cc: linux-wireless@vger.kernel.org,
        Wright Feng <wright.feng@cypress.com>,
        linux-firmware@kernel.org
Subject: Re: [PATCH] brcm: add firmware for BCM43430 802.11n chipset
Message-ID: <20160915140109.GE7853@merlin.infradead.org> (sfid-20160915_160114_603231_6CBEBD34)
References: <1473843865-29031-1-git-send-email-arend.vanspriel@broadcom.com>
 <69f27369-86dc-dc01-67d6-0e8fc1a6616c@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <69f27369-86dc-dc01-67d6-0e8fc1a6616c@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Sep 14, 2016 at 11:30:33AM +0200, Arend Van Spriel wrote:
> On 14-9-2016 11:04, Arend van Spriel wrote:
> > This patch releases firmware for the BCM43430 and BCM43438 chipset. The
> > latter is found on the Raspberry Pi 3.
> > 
> > Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> > Change-Id: I80aa84bf984b2d5572680b6f7febe94de22bd720
> > Reviewed-on: http://hnd-swgit.sj.broadcom.com:8080/7766
> 
> Yikes. Forgot to remove those Gerrit related tags. Do I need to send a
> V2 or can firmware-group take care of this?
> 

no big deal, i also switched the permissions to 644.

--kyle
