Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.171]:20446 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759336AbXKAWWB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Nov 2007 18:22:01 -0400
Received: by ug-out-1314.google.com with SMTP id z38so557029ugc
        for <linux-wireless@vger.kernel.org>; Thu, 01 Nov 2007 15:22:00 -0700 (PDT)
Message-ID: <472A5184.8040103@gmail.com> (sfid-20071101_222226_358318_F7FB06D6)
Date: Thu, 01 Nov 2007 23:21:56 +0100
From: Jiri Slaby <jirislaby@gmail.com>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Nick Kossifidis <mickflemm@gmail.com>
Subject: Re: [PATCH 5/7] ath5k: Move OFDM timings into a helper routine
References: <20071101043520.GC21987@pogo> <20071101043718.GD21987@pogo> <20071101043815.GE21987@pogo> <20071101043855.GF21987@pogo> <20071101215318.GC4182@pogo> <472A4BBD.4050207@gmail.com>
In-Reply-To: <472A4BBD.4050207@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/01/2007 10:57 PM, Jiri Slaby wrote:
> Note, that BUG can return (on configurations where !CONFIG_BUG). It is my fault
> writing you it won't, sorry! Could you post a patch which will add return from
> here and also from places where the BUG() is used in other places?

Ok, after a talk we agreed, that making the BUG() a void is non-recommended
option on embedded and we can let the patch as it is. Hence it is
Acked-by: Jiri Slaby <jirislaby@gmail.com>
