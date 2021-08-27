Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF46DC432BE
	for <linux-wireless@archiver.kernel.org>; Fri, 27 Aug 2021 18:10:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CA56C60234
	for <linux-wireless@archiver.kernel.org>; Fri, 27 Aug 2021 18:10:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229776AbhH0SLj (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 27 Aug 2021 14:11:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:60128 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229478AbhH0SLi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 27 Aug 2021 14:11:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3132360FDA;
        Fri, 27 Aug 2021 18:10:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630087849;
        bh=efycGMgOuRuAVC1cyTXxDuc5nH0HnGdY10ZNeZ60SFg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=N5qXYp6sslJgVdOBX06xEo7QcydjnZikyZvm+er0eeLigykfolKuTYigP0E5Q13mB
         hGSSsH5Sjr/kDtpVfuFyCj9BUiFmVnyO3J4Hbv2RMtNl+yZut3ecJ4v9SxrsMy7t9H
         fsFcDtkgJ6SAxbyVo1C9hY2N/KhrSwR2vRZuUOsMxOYgpCmDLCkwHQGrl05oxW0VXC
         rfM8hTtHaTsyfH4ffjQ8noWhIahbBVhR2c8GNDv+RXl80GgB4n5QXKoiUdzRJx75YX
         kbd8Uc5r02kqV356/smTgXQFe/3neZZlLcMa56A6fUVD4CPtHTa48nqLBFdAmvgPoq
         AxndqXFRM9AUg==
Date:   Fri, 27 Aug 2021 13:10:48 -0500
From:   Seth Forshee <sforshee@kernel.org>
To:     Victor Bayas <victorsbayas@gmail.com>
Cc:     wireless-regdb@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2] Update regulatory rules for Ecuador (EC)
Message-ID: <YSkqqHcnqQP1P/Bf@ubuntu-x1>
References: <20210826201026.5071-1-victorsbayas@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210826201026.5071-1-victorsbayas@gmail.com>
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Thu, Aug 26, 2021 at 03:10:26PM -0500, Victor Bayas wrote:
> Update the frequency ranges and power limits according to the current
> Ecuadorian norm [1], allow up to 160 MHz bandwidth on 5GHz.
> 
> [1] https://www.arcotel.gob.ec/wp-content/uploads/2018/04/NORMA-ESPECTRO-DE-USO-LIBRE-Y-ESPECTRO-PARA-USO-DETERMINADO-EN-BANDAS-LIBRES.pdf
> 
> Signed-off-by: Victor Bayas <victorsbayas@gmail.com>

Applied, thanks!
