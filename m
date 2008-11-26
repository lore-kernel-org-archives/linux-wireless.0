Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.187]:65298 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752801AbYKZCAT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Nov 2008 21:00:19 -0500
Received: by fk-out-0910.google.com with SMTP id 18so199587fkq.5
        for <linux-wireless@vger.kernel.org>; Tue, 25 Nov 2008 18:00:17 -0800 (PST)
Message-ID: <45e8e6c40811251754q4b08be7dn96308f3ae9f10123@mail.gmail.com> (sfid-20081126_030024_492967_797F60EB)
Date: Tue, 25 Nov 2008 17:54:24 -0800
From: "Andrey Yurovsky" <andrey@cozybit.com>
To: linux-wireless <linux-wireless@vger.kernel.org>
Subject: ath5k: mesh mode broken by commit "ath5k: Update PCU code"
Cc: ath5k-devel@lists.ath5k.org,
	"Nick Kossifidis" <mickflemm@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello.  I noticed that commit dc300b5c5291d779a53d83af960fdf9388bf0544
"ath5k: Update PCU code"  by Nick Kossifidis breaks Mesh Point
operation, which had been working right up to that patch.  As I am not
familiar with the antenna-related code that this is touching, can
someone please assist with resolving this problem?  Thanks,

  -Andrey
