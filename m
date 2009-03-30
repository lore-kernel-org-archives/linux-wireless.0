Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:12514 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750872AbZC3IQU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Mar 2009 04:16:20 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: linux-wireless@vger.kernel.org
Subject: Re: gcc error 385 in agg-tx.c
Date: Mon, 30 Mar 2009 09:15:16 +0100
Cc: ZeroBeat <ZeroBeat@gmx.de>
References: <49CF1245.1040804@gmx.de>
In-Reply-To: <49CF1245.1040804@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Message-Id: <200903301015.16869.hs4233@mail.mn-solutions.de> (sfid-20090330_101626_582191_11F8C0E6)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> =BBieee80211_agg_splice_packets=AB: /net/mac80211/agg-tx.c:385:
> Fehler: Implizite Deklaration der Funktion
> =BBskb_queue_splice_tail_init=AB

Most people can't decipher german error messages in an=20
international mailing list.

$ LANG=3Dc make
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
