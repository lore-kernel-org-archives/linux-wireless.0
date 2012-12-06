Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41611 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030197Ab2LFJEy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Dec 2012 04:04:54 -0500
Date: Thu, 6 Dec 2012 10:04:44 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Mykyta Iziumtsev <mykyta.iziumtsev@gmail.com>
Cc: wireless-regdb@lists.infradead.org,
	Arend van Spriel <arend@broadcom.com>,
	linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>,
	Pavel Chernyshev <pchernyshev@gmail.com>,
	Andrew Bordunov <andrew.bordunov@gmail.com>
Subject: Re: [PATCH v2] wireless-regdb: Update regulations for Ukraine
Message-ID: <20121206090443.GD2502@redhat.com> (sfid-20121206_100500_088540_8819E7C4)
References: <CAHc5FiWpUBUDh=8tDaaLRh9fHXT-k3EBj+KdoOGoR=BhYhzrVQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <CAHc5FiWpUBUDh=8tDaaLRh9fHXT-k3EBj+KdoOGoR=BhYhzrVQ@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Dec 04, 2012 at 11:27:55PM +0100, Mykyta Iziumtsev wrote:
> Add 5GHz band and mark 2.4GHz and 5GHz as NO-OUTDOOR according to
> "Рішення про затвердження Переліку радіоелектронних засобів
> та випромінювальних пристроїв, для експлуатації яких не потрібні
> дозволи на експлуатацію" from 27 May 2010.
> 
> Ref:
> * #914 / 06 Sep 2007: http://www.ucrf.gov.ua/uk/doc/nkrz/1196068874
> * #1174 / 23 Oct 2008: http://www.nkrz.gov.ua/uk/activities/ruling/1225269361
> (appendix 8)

Since regulatory maintainer does not understand Ukrainian,
there is little chance to get this patch applied.

IMHO this can be solved by:

* having official English translation of those document on gov.ua site
* provide patch by wlan chip vendor, confirmed by legal deparament of
  the vendor
* provide patch by some known Ukrainian kernel developer, someone
  who is know by regulatory maintainer and can be trust

Stanislaw
