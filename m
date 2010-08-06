Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hyde.gogi.tv ([87.106.167.24]:52227 "EHLO hyde.gogi.tv"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760555Ab0HFKJo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Aug 2010 06:09:44 -0400
Received: from pippo.localnet (p5B176F11.dip.t-dialin.net [91.23.111.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by hyde.gogi.tv (Postfix) with ESMTPSA id 82FD44800B
	for <linux-wireless@vger.kernel.org>; Fri,  6 Aug 2010 10:09:42 +0000 (UTC)
From: Daniel Haid <d.haid@gogi.tv>
To: linux-wireless@vger.kernel.org
Subject: Re: radiotap rate no longer supported in mac80211?
Date: Fri, 6 Aug 2010 12:09:26 +0200
References: <201008051614.11546.d.haid@gogi.tv> <AANLkTikM_hyo71PyMLQ9z63FnOkusbKQb7OkRWfOvSTZ@mail.gmail.com>
In-Reply-To: <AANLkTikM_hyo71PyMLQ9z63FnOkusbKQb7OkRWfOvSTZ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201008061209.26382.d.haid@gogi.tv>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2010-06-15 Pavel Roskin wrote:
> I don't feel good about pushing a patch that makes the code more complex
> without knowing the use case.

I need this as well. How can it be implemented correctly, so that it can
be accepted?
