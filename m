Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f176.google.com ([209.85.212.176]:35062 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751082AbbFHPCX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Jun 2015 11:02:23 -0400
Received: by wiga1 with SMTP id a1so89702597wig.0
        for <linux-wireless@vger.kernel.org>; Mon, 08 Jun 2015 08:02:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAOFH_kGD8nt8H6ZxA94cX0yrdXeBwT5Nuw380Kyb_UXz7ATMAg@mail.gmail.com>
References: <CAOFH_kGD8nt8H6ZxA94cX0yrdXeBwT5Nuw380Kyb_UXz7ATMAg@mail.gmail.com>
Date: Mon, 8 Jun 2015 17:02:22 +0200
Message-ID: <CAOFH_kF=iHOyvv1WrB0pwHmYniYJf7WM52k1Nrksc+pmY8h4AQ@mail.gmail.com> (sfid-20150608_170226_977427_89F13EBA)
Subject: Fwd: TX99 rate control
From: Mathieu Slabbinck <matty.slabbinck@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all,

I'm trying to figure out how to get rate control working in TX99.
Currently it's forced in code to rate = &tx_info->control.rates[0];

Every time I force/try anything besides "0" (which is the value of
tx_info->control.rates[0]) the module won't start radiating.

Can anyone provide any help with this subject?

Kind regards

Mathieu
