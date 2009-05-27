Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ip78-183-211-87.adsl2.static.versatel.nl ([87.211.183.78]:36086
	"EHLO god.dyndns.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754106AbZE0St4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 May 2009 14:49:56 -0400
Date: Wed, 27 May 2009 20:49:56 +0200
From: henk <henk@god.dyndns.org>
To: Bob Copeland <me@bobcopeland.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: ath5k in AP mode works!! (but sometimes with an oops, and a panic)
Message-ID: <20090527184956.GA14462@god.dyndns.org>
References: <20090524222027.GA32198@god.dyndns.org> <b6c5339f0905270550y50a925fbk4b891db8bbb9d9b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <b6c5339f0905270550y50a925fbk4b891db8bbb9d9b@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


I added some extra checks in ath5k/base.c
see http://bugzilla.kernel.org/show_bug.cgi?id=13381#c3

This resolves the panic for now.

- henk

