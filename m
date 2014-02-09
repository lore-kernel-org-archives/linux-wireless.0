Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0004.hostedemail.com ([216.40.44.4]:44084 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751523AbaBITJU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 Feb 2014 14:09:20 -0500
Message-ID: <1391972955.3178.1.camel@joe-AO722> (sfid-20140209_201017_796586_2C3A3596)
Subject: Re: [PATCH 09/28] Remove ATHEROS_AR231X
From: Joe Perches <joe@perches.com>
To: Richard Weinberger <richard@nod.at>
Cc: Jiri Slaby <jirislaby@gmail.com>,
	Nick Kossifidis <mickflemm@gmail.com>,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	"open list:ATHEROS ATH5K WIR..." <linux-wireless@vger.kernel.org>,
	"open list:ATHEROS ATH5K WIR..." <ath5k-devel@lists.ath5k.org>,
	"open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
	open list <linux-kernel@vger.kernel.org>
Date: Sun, 09 Feb 2014 11:09:15 -0800
In-Reply-To: <1391971686-9517-10-git-send-email-richard@nod.at>
References: <1391971686-9517-1-git-send-email-richard@nod.at>
	 <1391971686-9517-10-git-send-email-richard@nod.at>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2014-02-09 at 19:47 +0100, Richard Weinberger wrote:
> The symbol is an orphan, get rid of it.

This description seems very incomplete as the symbol
is being used quite a bit and the code the symbol
controls is being deleted as well as the symbol.


