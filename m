Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.31]:33331 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751380AbYGIAZM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Jul 2008 20:25:12 -0400
Received: by yw-out-2324.google.com with SMTP id 9so1246608ywe.1
        for <linux-wireless@vger.kernel.org>; Tue, 08 Jul 2008 17:24:54 -0700 (PDT)
Subject: Re: [PATCH] libertas: fix memory alignment problems on the blackfin
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Ihar Hrachyshka <ihar.hrachyshka@promwad.com>
Cc: libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org
In-Reply-To: <20080709031850.2e7bf50f@promwad.com>
References: <20080709031850.2e7bf50f@promwad.com>
Content-Type: text/plain
Date: Tue, 08 Jul 2008 17:24:52 -0700
Message-Id: <1215563092.476.58.camel@brick> (sfid-20080709_022521_375213_D0DB1623)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2008-07-09 at 03:18 +0300, Ihar Hrachyshka wrote:
> Fixing unaligned memory access on the blackfin architecture (maybe on the ARM also).
> 

There's helpers for this now: get_unaligned_le16

Cheers,

Harvey

