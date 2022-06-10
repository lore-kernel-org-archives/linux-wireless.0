Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 969CFC43334
	for <linux-wireless@archiver.kernel.org>; Fri, 10 Jun 2022 13:49:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237780AbiFJNt6 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 10 Jun 2022 09:49:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244057AbiFJNt5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 10 Jun 2022 09:49:57 -0400
Received: from mail.toke.dk (mail.toke.dk [IPv6:2a0c:4d80:42:2001::664])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 520F6396AB
        for <linux-wireless@vger.kernel.org>; Fri, 10 Jun 2022 06:49:55 -0700 (PDT)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=toke.dk; s=20161023;
        t=1654868994; bh=zil8mYWDXNWzrYFcgjo20HtZ28WaJISVny9knb0R/xY=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=x/NYYhjLFn1PnQjbonVKObab742pbEl97CbrQFV+oNhkYWmHDfvmB30RqsfU8XKu3
         k4YB5dwCHBUv0M24zOWnwGyLZ9490j3Zoyr7SPVUEldIFRZpvuNkLsue7ejjgzP1XB
         nWZyrpi6vZMHgSa3vILbAtTJgkfqKRLQETwws/DrR2lAGk6z9IWnzeuo5+fNiagP+q
         Z9pMSYUGW4ysQQo/GrwXc7CWXPmZuLZwSLc9Yptw/SzefkisxvEOI72ONP/idqWLTv
         nV8g+w0D9mpKhNmsu2SowgaG7HhGLNYa5vAb7ddZdi+stUZXDh7qwwZiWLXjnmCzWA
         P0cFtXNwES9cw==
To:     Kalle Valo <kvalo@kernel.org>, ath11k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org
Subject: Re: [PATCH wireless v2 1/2] dt-bindings: net: wireless: ath9k:
 Change Toke as maintainer
In-Reply-To: <20220610133640.10810-1-kvalo@kernel.org>
References: <20220610133640.10810-1-kvalo@kernel.org>
Date:   Fri, 10 Jun 2022 15:49:54 +0200
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <87edzw4ohp.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Kalle Valo <kvalo@kernel.org> writes:

> From: Kalle Valo <quic_kvalo@quicinc.com>
>
> Toke now maintains ath9k so update DT bindings as well.
>
> Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>

Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@toke.dk>
