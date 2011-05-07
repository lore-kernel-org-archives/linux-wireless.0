Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:38713 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756029Ab1EGUOx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 May 2011 16:14:53 -0400
MIME-Version: 1.0
In-Reply-To: <1304771519.2227.6.camel@x61.thuisdomein>
References: <1304771519.2227.6.camel@x61.thuisdomein>
Date: Sat, 7 May 2011 21:14:52 +0100
Message-ID: <BANLkTinE4zDXE6VDS=yc1SmCCEbAn70Rcw@mail.gmail.com> (sfid-20110507_221520_272211_B7B6EEF1)
Subject: Re: [PATCH] [RESEND] iwl4965: drop a lone pr_err()
From: julie Sullivan <kernelmail.jms@gmail.com>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> iwl4965_rate_control_register() prints a message at KERN_ERR level.

> -       pr_err("Registering 4965 rate control operations\n");

Yes, I noticed this message on boot too and found it a tad confusing...
('Rate control operations'?? 4,965 of them?)
:-)  At least I know what it is now. Thanks, Paul.

Julie
