Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:48944 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751663AbbIYAAG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Sep 2015 20:00:06 -0400
Date: Thu, 24 Sep 2015 20:00:04 -0400
From: Kyle McMartin <kyle@infradead.org>
To: Arend van Spriel <arend@broadcom.com>
Cc: linux-wireless@vger.kernel.org, Rafal Milecki <zajec5@gmail.com>
Subject: Re: [PATCH] brcmfmac: firmware refresh for BCM43602 PCIE devices
Message-ID: <20150925000004.GF26918@merlin.infradead.org> (sfid-20150925_020011_242720_F30C7F12)
References: <1443120304-11153-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1443120304-11153-1-git-send-email-arend@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Sep 24, 2015 at 08:45:04PM +0200, Arend van Spriel wrote:
> A number of end-users reported issues with BCM43602 on the 2015
> MacBook Pro. It turned out the previously released firmware did
> not properly support that device [1]. Hence an update of the STA
> firmware and while at it refresh the AP firmware as well. The
> latter has been tested using Netgear R8000. The STA firmware has
> been tested on MacBook Pro.
> 

Are there version numbers we could update in WHENCE to make this
easier to track?

regards, --jkkm

> [1] https://bugzilla.kernel.org/show_bug.cgi?id=100201
> 
> Cc: Rafal Milecki <zajec5@gmail.com>
> Tested-by: Knuth Posern <knuth@posern.org>
> Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
> Signed-off-by: Arend van Spriel <arend@broadcom.com>
> ---
> This patch fixes a couple of issues mentioned in kernel bugzilla
> #100201 with 2015 MacBook Pro machines using this wifi chipset.
> 
> The patch applies to master branch of the linux-firmware repository
> on top of commit f88e5c2e2ff5 ("Merge 'c11384c' of
> git://people.freedesktop.org/~vivijim/linux-firmware...").
