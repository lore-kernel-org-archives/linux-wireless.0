Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:33399 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752202AbYAMTdB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Jan 2008 14:33:01 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Ivo van Doorn <ivdoorn@gmail.com>
Subject: Re: [Rt2400-devel] [PATCH] rt2x00: remove unused variable
Date: Sun, 13 Jan 2008 20:31:55 +0100
Cc: rt2400-devel@lists.sourceforge.net,
	Stefano Brivio <stefano.brivio@polimi.it>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
References: <20080113194834.677af663@morte> <200801132014.53522.IvDoorn@gmail.com>
In-Reply-To: <200801132014.53522.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200801132031.55857.mb@bu3sch.de> (sfid-20080113_193307_315226_044A6523)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 13 January 2008 20:14:53 Ivo van Doorn wrote:
> Hi,
> 
> > Remove an unused variable that caused a warning while building. Please note
> > that the pipe obtained there isn't used anywhere else.
> 
> This patch is in wireless-2.6 already...

No it is not in wireless-2.6.

-- 
Greetings Michael.
