Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:41800 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753511AbYEGO4O (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 May 2008 10:56:14 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Daniel Kubiak <sor@czlug.icis.pcz.pl>
Subject: Re: Conflict with b44 ethernet module
Date: Wed, 7 May 2008 16:55:45 +0200
Cc: linux-wireless@vger.kernel.org
References: <4821BA14.5080609@czlug.icis.pcz.pl>
In-Reply-To: <4821BA14.5080609@czlug.icis.pcz.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200805071655.45446.mb@bu3sch.de> (sfid-20080507_165523_065663_F8EEB29A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 07 May 2008 16:17:56 Daniel Kubiak wrote:
> Hello,
> 
> I have problem with b44 driver after install compact-wireless 
> (2008-05-07). I can't load this module. In dmesg I can see:

You can't use compat, if you use the in-kernel b44.

-- 
Greetings Michael.
