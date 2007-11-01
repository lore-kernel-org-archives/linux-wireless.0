Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.177]:51296 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753350AbXKAW1n (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Nov 2007 18:27:43 -0400
Received: by py-out-1112.google.com with SMTP id u77so1194059pyb
        for <linux-wireless@vger.kernel.org>; Thu, 01 Nov 2007 15:27:43 -0700 (PDT)
Message-ID: <40f31dec0711011527o20175aa0y66118941900a5518@mail.gmail.com> (sfid-20071101_222747_729114_B505165A)
Date: Fri, 2 Nov 2007 00:27:42 +0200
From: "Nick Kossifidis" <mickflemm@gmail.com>
To: "Jiri Slaby" <jirislaby@gmail.com>
Subject: Re: [PATCH 5/7] ath5k: Move OFDM timings into a helper routine
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	"John Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <472A5184.8040103@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <20071101043520.GC21987@pogo> <20071101043718.GD21987@pogo>
	 <20071101043815.GE21987@pogo> <20071101043855.GF21987@pogo>
	 <20071101215318.GC4182@pogo> <472A4BBD.4050207@gmail.com>
	 <472A5184.8040103@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2007/11/2, Jiri Slaby <jirislaby@gmail.com>:
> On 11/01/2007 10:57 PM, Jiri Slaby wrote:
> > Note, that BUG can return (on configurations where !CONFIG_BUG). It is my fault
> > writing you it won't, sorry! Could you post a patch which will add return from
> > here and also from places where the BUG() is used in other places?
>
> Ok, after a talk we agreed, that making the BUG() a void is non-recommended
> option on embedded and we can let the patch as it is. Hence it is
> Acked-by: Jiri Slaby <jirislaby@gmail.com>
>

Acked-by: Nick Kossifidis <mickflemm@gmail.com>

-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
