Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.179]:47084 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754408AbXGDRmc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Jul 2007 13:42:32 -0400
Received: by py-out-1112.google.com with SMTP id u77so3974906pyb
        for <linux-wireless@vger.kernel.org>; Wed, 04 Jul 2007 10:42:31 -0700 (PDT)
Message-ID: <8e8340660707041042r5d6ae598v40215f1b14ce477@mail.gmail.com>
Date: Wed, 4 Jul 2007 10:42:31 -0700
From: "Luis Carlos Cobo" <luisca@cozybit.com>
To: "Holger Schurig" <hs4233@mail.mn-solutions.de>
Subject: Re: Fwd: drivers/net/wireless/libertas/rx.c: use-after-free
Cc: "Marcelo Tosatti" <marcelo@kvack.org>,
	libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
	"Adrian Bunk" <bunk@stusta.de>
In-Reply-To: <200707040851.06156.hs4233@mail.mn-solutions.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
References: <200706302114.53985.hs4233@mail.mn-solutions.de>
	 <20070703195633.GA6325@dmt>
	 <200707040851.06156.hs4233@mail.mn-solutions.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 7/3/07, Holger Schurig <hs4233@mail.mn-solutions.de> wrote:
> When is "is coming out soon" ???  If it's really soon, we
> shouldn't maybe commit my remove adapter->linkmode patch :-)

Yes, really soon,  but don't worry, linkmode and radio were being
removed anyway. However process_rxed_802_1 will be used. I will send
the patch against libertas branch head tomorrow the latest.

-- 
Luis Carlos Cobo Rus       GnuPG ID: 44019B60
cozybit Inc.
