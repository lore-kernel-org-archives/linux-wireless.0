Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f181.google.com ([209.85.212.181]:43395 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753022AbaJFSRF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Oct 2014 14:17:05 -0400
Received: by mail-wi0-f181.google.com with SMTP id hi2so5517475wib.8
        for <linux-wireless@vger.kernel.org>; Mon, 06 Oct 2014 11:17:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20141002181608.GA24110@mwanda>
References: <20141002181608.GA24110@mwanda>
Date: Mon, 6 Oct 2014 11:17:03 -0700
Message-ID: <CA++WF2PjewCZRu=enHhDs7V6Jj4SEjvPWyYJjWev5bNoCLxuNQ@mail.gmail.com> (sfid-20141006_201709_412546_5647B53B)
Subject: Re: [PATCH] Check ieee80211softmac_auth_resp kmalloc result
From: Stanislav Yakovlev <stas.yakovlev@gmail.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Dan,

> So far as I can see this is harmless because we never use ->ibss_dfs
> and we should just delete it along with all the related code?

Yes, you are right. This code is not used by ipw2x00 driver, so it can
be deleted. Will you send a patch?

Stanislav.
