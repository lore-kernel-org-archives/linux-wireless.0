Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:4715 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753510Ab2LHJzy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 8 Dec 2012 04:55:54 -0500
Message-ID: <50C30EA0.9080103@broadcom.com> (sfid-20121208_105600_032929_5DCC79F4)
Date: Sat, 8 Dec 2012 10:55:44 +0100
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Stanislaw Gruszka" <sgruszka@redhat.com>
cc: "Mykyta Iziumtsev" <mykyta.iziumtsev@gmail.com>,
	wireless-regdb@lists.infradead.org, linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>,
	"Pavel Chernyshev" <pchernyshev@gmail.com>,
	"Andrew Bordunov" <andrew.bordunov@gmail.com>
Subject: Re: [PATCH v2] wireless-regdb: Update regulations for Ukraine
References: <CAHc5FiWpUBUDh=8tDaaLRh9fHXT-k3EBj+KdoOGoR=BhYhzrVQ@mail.gmail.com>
 <20121206090443.GD2502@redhat.com>
In-Reply-To: <20121206090443.GD2502@redhat.com>
Content-Type: text/plain;
 charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/06/2012 10:04 AM, Stanislaw Gruszka wrote:
> On Tue, Dec 04, 2012 at 11:27:55PM +0100, Mykyta Iziumtsev wrote:
>> Add 5GHz band and mark 2.4GHz and 5GHz as NO-OUTDOOR according to
>> "Рішення про затвердження Переліку радіоелектронних засобів
>> та випромінювальних пристроїв, для експлуатації яких не потрібні
>> дозволи на експлуатацію" from 27 May 2010.
>>
>> Ref:
>> * #914 / 06 Sep 2007: http://www.ucrf.gov.ua/uk/doc/nkrz/1196068874
>> * #1174 / 23 Oct 2008: http://www.nkrz.gov.ua/uk/activities/ruling/1225269361
>> (appendix 8)
> 
> Since regulatory maintainer does not understand Ukrainian,
> there is little chance to get this patch applied.
> 
> IMHO this can be solved by:
> 
> * having official English translation of those document on gov.ua site

This is always a problem and unlikely to be solved.

> * provide patch by wlan chip vendor, confirmed by legal deparament of
>   the vendor

Legal department is not typically (directly) involved in this, but we
(Broadcom) have a regulatory department. However, there are OEMs
involved as well and some do their own FCC/regulatory certification. The
reason why I suggested adding references in the database is that I
wanted to get our regulatory department involved to validate at least
the correctness of the reference itself. Ideally, I would want them to
look at the rules itself.

> * provide patch by some known Ukrainian kernel developer, someone
>   who is know by regulatory maintainer and can be trust

I think John relies on community members watching the mailing list that
are affiliated with the chip vendors. Especially, when the url takes him
to some ukranian document :-)

> Stanislaw
> 

Gr. AvS

