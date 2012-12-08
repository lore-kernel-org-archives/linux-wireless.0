Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ia0-f181.google.com ([209.85.210.181]:56602 "EHLO
	mail-ia0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751968Ab2LHJVV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 8 Dec 2012 04:21:21 -0500
Received: by mail-ia0-f181.google.com with SMTP id s32so2217359iak.12
        for <linux-wireless@vger.kernel.org>; Sat, 08 Dec 2012 01:21:21 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20121206090443.GD2502@redhat.com>
References: <CAHc5FiWpUBUDh=8tDaaLRh9fHXT-k3EBj+KdoOGoR=BhYhzrVQ@mail.gmail.com>
 <20121206090443.GD2502@redhat.com>
From: Andrii Bordunov <andrew.bordunov@gmail.com>
Date: Sat, 8 Dec 2012 11:13:25 +0200
Message-ID: <CAHgdZf+TYEZkLG13sWkYPCz2Qah+HBokFwyz9WiuegGd6WUBHQ@mail.gmail.com> (sfid-20121208_102138_437273_BEC92B97)
Subject: Re: [PATCH v2] wireless-regdb: Update regulations for Ukraine
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Mykyta Iziumtsev <mykyta.iziumtsev@gmail.com>,
	wireless-regdb@lists.infradead.org,
	Arend van Spriel <arend@broadcom.com>,
	linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>,
	Pavel Chernyshev <pchernyshev@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There is really a little chance in this case. English translation is
absent for the referenced docs and I emailed UCRF several months ago
regarding terminology clarifications but got no response. Maybe there
are more chances with traditional mail or personal visit but I'd not
put a lot on that.

Regarding 2nd and 3rd cases I have no real assumptions at all. Anyway,
it would be better to know John's opinion by himself here.



2012/12/6 Stanislaw Gruszka <sgruszka@redhat.com>:
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
> * provide patch by wlan chip vendor, confirmed by legal deparament of
>   the vendor
> * provide patch by some known Ukrainian kernel developer, someone
>   who is know by regulatory maintainer and can be trust
>
> Stanislaw
