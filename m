Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:58083 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754113Ab1AaVeL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Jan 2011 16:34:11 -0500
Received: by qwa26 with SMTP id 26so5958666qwa.19
        for <linux-wireless@vger.kernel.org>; Mon, 31 Jan 2011 13:34:10 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <AANLkTinuFzBMMLd08Zpkf8iGBO-YdM2Ni-KtNCNxuUbT@mail.gmail.com>
References: <AANLkTim3CG+aN9QGhGOfBD9+BSYsgQW_ACC0o+k9H-rt@mail.gmail.com> <AANLkTinuFzBMMLd08Zpkf8iGBO-YdM2Ni-KtNCNxuUbT@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 31 Jan 2011 13:33:50 -0800
Message-ID: <AANLkTi=b-Tm7r1eODgAQqpQJuimD0+dQkHFB4YV06kES@mail.gmail.com>
Subject: Review of EN 301 893 1.5.1 and 1.6.1 changes
To: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	Michael Green <Michael.Green@atheros.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	wireless-regdb@lists.infradead.org
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Kathy Giori <Kathy.Giori@atheros.com>,
	David Quan <David.Quan@atheros.com>,
	"John W. Linville" <linville@tuxdriver.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

FYI - European conformance spec for 5 GHz Radio LANs has some slight
modifications which Johannes has pointed out which we have reviewed
today in consideration for our new DFS design. The skinny is that our
implementation of using 3 regions are OK and we will move forward with
that. Below are some small meeting notes on this.

EN 301 893 1.5.1 - new pulse patterns - in effect now (Michael will
confirm) - all rules harmonized, all countries will use the same of
set of pulse patterns. Countries won't be able to pick and choose, all
countries must abide by this.

EN 301 893 1.6.1 - isn't finished yet, it will take effect 6 months to
a year to take effect. 0.8us pulse is what we support today, this spec
pushes the narrower pulse width of 0.5us. Countries won't be able to
pick and choose, all countries must abide by this.

Based on our review today we are OK to keep the US, ETSI, JP
categories for DFS regions. We also do not foresee any future changes
which will break this design. The biggest wild card will be FCC which
is currently reviewing DFS rules but as far as we can tell there is
nothing on the roadmap to allow dynamic configurations for DFS
parameters.

  Luis
