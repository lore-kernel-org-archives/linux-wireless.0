Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perches-mx.perches.com ([206.117.179.246]:51046 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751392Ab3HULUT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Aug 2013 07:20:19 -0400
Message-ID: <1377084018.1936.16.camel@joe-AO722> (sfid-20130821_132031_416933_1C2A22E4)
Subject: Re: [PATCH 09/16] wcn36xx: Add smd.c
From: Joe Perches <joe@perches.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Eugene Krasnikov <k.eugene.e@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	wcn36xx@lists.infradead.org
Date: Wed, 21 Aug 2013 04:20:18 -0700
In-Reply-To: <1377072922.15268.4.camel@jlt4.sipsolutions.net>
References: <1377020479-16935-1-git-send-email-k.eugene.e@gmail.com>
	 <1377020479-16935-10-git-send-email-k.eugene.e@gmail.com>
	 <1377022333.2016.59.camel@joe-AO722>
	 <CAFSJ42ZMk6sN6povWHkSodk0J7pBvyak8sH-MqNXVhi_iSmq9Q@mail.gmail.com>
	 (sfid-20130821_095852_398872_A90920C7) <1377072922.15268.4.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-08-21 at 10:15 +0200, Johannes Berg wrote:
> It should really be u8* instead of void*, since void* pointer arithmetic
> isn't really defined I think?

Well, it is for gcc and void * arithmetic is
widely used throughout the kernel.


