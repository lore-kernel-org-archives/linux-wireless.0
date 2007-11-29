Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nz-out-0506.google.com ([64.233.162.227]:49300 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757253AbXK2EMJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Nov 2007 23:12:09 -0500
Received: by nz-out-0506.google.com with SMTP id s18so1315692nze
        for <linux-wireless@vger.kernel.org>; Wed, 28 Nov 2007 20:12:07 -0800 (PST)
Message-ID: <787b0d920711282012k38d6d2c8g2d9ae79c89b04059@mail.gmail.com> (sfid-20071129_041212_624563_9B731240)
Date: Wed, 28 Nov 2007 23:12:06 -0500
From: "Albert Cahalan" <acahalan@gmail.com>
To: "Holger Schurig" <hs4233@mail.mn-solutions.de>
Subject: Re: [PATCH] libertas: remove user-specified channel list
Cc: "Dan Williams" <dcbw@redhat.com>, linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	libertas-dev@lists.infradead.org
In-Reply-To: <200711281730.21327.hs4233@mail.mn-solutions.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <200711281730.21327.hs4233@mail.mn-solutions.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Nov 28, 2007 11:30 AM, Holger Schurig <hs4233@mail.mn-solutions.de> wrote:
> Remove the ability to specify channels to scan via debugfs

Why are you ripping out functionality? At the very least,
that ought to be justified in the changelog comment.
