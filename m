Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C6DFC433EF
	for <linux-wireless@archiver.kernel.org>; Mon, 21 Mar 2022 16:03:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350611AbiCUQEz (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 21 Mar 2022 12:04:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347575AbiCUQEw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 21 Mar 2022 12:04:52 -0400
Received: from mail.toke.dk (mail.toke.dk [IPv6:2a0c:4d80:42:2001::664])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F5091B7AE
        for <linux-wireless@vger.kernel.org>; Mon, 21 Mar 2022 09:03:25 -0700 (PDT)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=toke.dk; s=20161023;
        t=1647878604; bh=mZ+xHj38vst6fyOb4iE/JFPlidrwa33wmE1Md6zKCJA=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=femNJpaGMBOvacs6Ig3+LJBQWO0B1EvWG4dGAw6qgux7S0MstrHV+xUK7Red4rRka
         uIYaSj8mOZYDtNueRgChCyEyGBHr1QUS/oUUzQ9JXYlY3WSyy0IRn9j1iHLUzcGutq
         fUFUIp3/nk8H6VCMhOwoMWeSnb+FABHb3s9Z4dT3jN0phO4RD61QbFXeWPD9eC3ZhI
         fkGJipcUFTi+9o3VddXLcbXkFqqhgjKYyVNQtlXWazv0UIs0WJ2Rm5XKccrdYuVrc7
         oszDWr5Vo1k/WT9nNMEh4n+hYwRr/6RrMAHX2/JKwk/0bDnvzRM81RPwAWkNJ3uZ2P
         OuHvU6soh5cbw==
To:     Wenli Looi <wlooi@ucalgary.ca>
Cc:     Kalle Valo <kvalo@kernel.org>, linux-wireless@vger.kernel.org,
        ath9k-devel@qca.qualcomm.com, Wenli Looi <wlooi@ucalgary.ca>
Subject: Re: [PATCH 6/6] ath9k: add functions to get paprd rate mask
In-Reply-To: <20220320233010.123106-7-wlooi@ucalgary.ca>
References: <20220320233010.123106-1-wlooi@ucalgary.ca>
 <20220320233010.123106-7-wlooi@ucalgary.ca>
Date:   Mon, 21 Mar 2022 17:03:24 +0100
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <87sfrb8f8z.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Wenli Looi <wlooi@ucalgary.ca> writes:

> This removes some code duplication with le32_to_cpu. This may also be
> required for QCN550x support, to provide an abstraction over the
> underlying EEPROM format.
>
> Signed-off-by: Wenli Looi <wlooi@ucalgary.ca>

Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@toke.dk>
