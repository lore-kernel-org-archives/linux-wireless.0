Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wr-out-0506.google.com ([64.233.184.234]:35234 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754309AbYAGRmO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Jan 2008 12:42:14 -0500
Received: by wr-out-0506.google.com with SMTP id c49so393524wra.1
        for <linux-wireless@vger.kernel.org>; Mon, 07 Jan 2008 09:42:13 -0800 (PST)
Message-ID: <43e72e890801070942y5abcc8acs31ac446d67414483@mail.gmail.com> (sfid-20080107_174219_356987_0F8ECBCA)
Date: Mon, 7 Jan 2008 12:42:13 -0500
From: "Luis R. Rodriguez" <mcgrof@winlab.rutgers.edu>
To: "Hauke Mehrtens" <hauke@hauke-m.de>
Subject: Re: rtl8187 rate control doesn't work
Cc: "Michael Wu" <flamingice@sourmilk.net>,
	linux-kernel@vger.kernel.org,
	"Stefano Brivio" <stefano.brivio@polimi.it>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <47824D25.5090005@hauke-m.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <477F9890.5050107@hauke-m.de>
	 <43e72e890801051354v280c0ceeo78790bb5f1f45314@mail.gmail.com>
	 <47824D25.5090005@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Jan 7, 2008 11:02 AM, Hauke Mehrtens <hauke@hauke-m.de> wrote:
> There is an other Problem.
>
> iwconfig shows me "Bit Rate=1 Mb/s" the hole time, but I'm able to
> download with an average of 440K/s as wget says.
>
> It's with PID rate control algorithm.

Thanks for reporting this, how'd it go with simple rate control
algorithm instead?

  Luis
