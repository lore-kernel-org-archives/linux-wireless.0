Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f180.google.com ([74.125.82.180]:37898 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754640Ab3BWLl4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Feb 2013 06:41:56 -0500
Received: by mail-we0-f180.google.com with SMTP id k14so1213189wer.11
        for <linux-wireless@vger.kernel.org>; Sat, 23 Feb 2013 03:41:54 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <512891D5.80504@fisher-privat.net>
References: <CAJ-Vmon-z50jmxz6hiAjk5kR47P3BcHHGsNqGHMgJaFtccV65g@mail.gmail.com>
	<512891D5.80504@fisher-privat.net>
Date: Sat, 23 Feb 2013 03:41:54 -0800
Message-ID: <CAJ-Vmon=o7Zs8BDSH1_cKoob20+qbPN2FgAxxPdpUVCv9fLrUA@mail.gmail.com> (sfid-20130223_124205_333117_2D5A2BB5)
Subject: Re: [ath9k-devel] [RFT] ath9k_htc - please test new images
From: Adrian Chadd <adrian@freebsd.org>
To: Oleksij Rempel <bug-track@fisher-privat.net>
Cc: ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 23 February 2013 01:54, Oleksij Rempel <bug-track@fisher-privat.net> wrote:
>
> Hi Adrian,
>
> current driver has this check:
> htc_drv_init.c:     priv->fw_version_minor != MINOR_VERSION_REQ) {
> htc_drv_init.c:                 MAJOR_VERSION_REQ, MINOR_VERSION_REQ);
>
> so it wont accept 1.4. Currently i compiling kernel without this
> restriction. Then i'll be able to test it.

Oops! Guess I shouldn't have bumped the version numbers :-)

Thanks,



Adrian
