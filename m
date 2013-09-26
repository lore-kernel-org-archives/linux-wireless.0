Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 174-143-244-95.static.cloud-ips.com ([174.143.244.95]:36620
	"EHLO mail.catnarok.net" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1750853Ab3IZBRc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Sep 2013 21:17:32 -0400
Date: Thu, 26 Sep 2013 00:54:39 +0000
From: Michael Stolovitzsky <emestee@catnarok.net>
To: linux-wireless@vger.kernel.org
Subject: Re: bcma 3.12-rc1 scheduling while atomic
Message-ID: <20130926005439.GA19054@mail.catnarok.net> (sfid-20130926_031735_456695_0FBEBF8A)
References: <1380142945.23272.42.camel@dcbw.foobar.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1380142945.23272.42.camel@dcbw.foobar.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 13-09-25, Dan Williams wrote:

> [    7.607842] BUG: scheduling while atomic: NetworkManager/523/0x00000200
[...]

I am observing the same with BCM4313. Let me know if I can help in any way.
