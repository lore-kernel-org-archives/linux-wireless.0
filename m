Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mfe1.polimi.it ([131.175.12.23]:36481 "EHLO polimi.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751849AbYAWL0F (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Jan 2008 06:26:05 -0500
Date: Wed, 23 Jan 2008 12:15:51 +0100
From: Stefano Brivio <stefano.brivio@polimi.it>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: davem@davemloft.net, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org
Subject: Re: pull request: wireless-2.6 'upstream' 2008-01-22
Message-ID: <20080123121551.4586e706@morte> (sfid-20080123_112614_562102_803CFB13)
In-Reply-To: <20080123014521.GG3206@tuxdriver.com>
References: <20080123014521.GG3206@tuxdriver.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 22 Jan 2008 20:45:21 -0500
"John W. Linville" <linville@tuxdriver.com> wrote:

>       b43legacy: Remove the PHY spinlock

I hope you tested this. I still haven't been able to (I received the
needed hardware yesterday), and Michael said that the patch has been
compile-tested only.


-- 
Ciao
Stefano
