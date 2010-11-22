Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:48248 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751810Ab0KVPjp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Nov 2010 10:39:45 -0500
Subject: Re: Use case for the radiotap rate patch
From: Johannes Berg <johannes@sipsolutions.net>
To: Roberto Riggio <roberto.riggio@create-net.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <4CE8F8D9.1020201@create-net.org>
References: <4CE8F8D9.1020201@create-net.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 22 Nov 2010 07:39:43 -0800
Message-ID: <1290440383.5718.2.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2010-11-21 at 11:47 +0100, Roberto Riggio wrote:

> Also, which would be the way to support the multi-rate retry chain from 
> user-space?
> I'm currently playing with some custom RC algorithms in users space 
> using the
> click modular router, but I cannot take advantage of the mrr.

radiotap now has a way to specify one attribute multiple times, so that
should be used for MRR

johannes

