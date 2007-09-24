Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.189]:45296 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755514AbXIXSmk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Sep 2007 14:42:40 -0400
Received: by nf-out-0910.google.com with SMTP id g13so1457239nfb
        for <linux-wireless@vger.kernel.org>; Mon, 24 Sep 2007 11:42:39 -0700 (PDT)
Message-ID: <46F8051C.8030301@gmail.com>
Date: Mon, 24 Sep 2007 20:42:36 +0200
From: Jiri Slaby <jirislaby@gmail.com>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	mickflemm@gmail.com, Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/2 try 2] Net: ath5k, split hw into hw, phy and initvals
References: <3175698652466923884@pripojeni.net> <43e72e890709241024pd364c31k4a41c030f192cf0d@mail.gmail.com>
In-Reply-To: <43e72e890709241024pd364c31k4a41c030f192cf0d@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/24/2007 07:24 PM, Luis R. Rodriguez wrote:
> * #if 0's need to go, lets just remove this code instead.

Which code do you mean exactly, there are also parts that might be needed in the
future?

thanks,
-- 
Jiri Slaby (jirislaby@gmail.com)
Faculty of Informatics, Masaryk University
