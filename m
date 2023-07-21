Return-Path: <linux-wireless-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF927EB64DD
	for <linux-wireless@archiver.kernel.org>; Fri, 21 Jul 2023 20:57:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230373AbjGUU5n (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 21 Jul 2023 16:57:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229642AbjGUU5m (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 21 Jul 2023 16:57:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 269C2B3
        for <linux-wireless@vger.kernel.org>; Fri, 21 Jul 2023 13:57:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 69C8761D6D
        for <linux-wireless@vger.kernel.org>; Fri, 21 Jul 2023 20:57:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D293C433C8;
        Fri, 21 Jul 2023 20:57:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1689973059;
        bh=XqUMwsvgw3jy5Kr17SRjd3dRflDXazCDyrNP2evsJWE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Kj4ShIMb1pZ/8ePXKf3qYxLvSFSfAvZMgJis7X4Lgfm9CusSeA1H2q28QVXlHwXSL
         CIl7IBuyb8DrSEcAABkhcN7BtthANL4dH70KG3QfKU7RrqfZ9P6wBS6C0ynPE2aotr
         y1jkeEFBorfxIpuS5XG637eKM6CSRnf5rC73tbyQCFGfesKXHWOhKk/+/HpTLUhHn/
         edXZ/LaGz2uu1zXd9KLSkcb8wtCYT/YahdxsqZVn26ETixSvqKk6a6VFmA19QOokEo
         Xy+QbyxJccgqh0I2znaGp7q0Z2CPyX/sxHANw2Mg4iQoOL+qMCyvn7+8y4UIMSaqDk
         FCs2ez+do+wLg==
Date:   Fri, 21 Jul 2023 15:57:38 -0500
From:   Seth Forshee <sforshee@kernel.org>
To:     wireless-regdb@lists.infradead.org
Cc:     Mohammed Ismail <m.ismael@gmail.com>,
        linux-wireless@vger.kernel.org
Subject: Re: [wireless-regdb] [PATCH] wireless-regdb: Update regulatory rules
 for Egypt (EG) from March 2022 guidelines
Message-ID: <ZLrxQrN/WVtVDc9k@ubuntu-x1>
References: <20230711153945.1004817-1-sforshee@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230711153945.1004817-1-sforshee@kernel.org>
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Tue, Jul 11, 2023 at 10:39:45AM -0500, Seth Forshee wrote:
> The radio spectrum guidelines document from March 2022 [1] contains no
> restriction on outdoor operation and allows use of 57-66 GHz.
> 
> [1] https://www.tra.gov.eg/wp-content/uploads/2022/03/EGY-NTRA-March-2022-SRD_English_Final.pdf
> 
> Signed-off-by: Seth Forshee <sforshee@kernel.org>

Applied.
