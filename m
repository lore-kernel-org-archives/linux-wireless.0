Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:1888 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753427Ab2JIHxH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Oct 2012 03:53:07 -0400
Message-ID: <5073D7DC.8080609@broadcom.com> (sfid-20121009_095315_733522_41BFDF92)
Date: Tue, 9 Oct 2012 09:53:00 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: wireless-regdb@lists.infradead.org,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
Subject: Re: [wireless-regdb] [PATCH] wireless-regdb: Update regulations
 for Ukraine
References: <CAHc5FiXv=aeKKwpz2RP3ho+d-eggxfGuECk1deyNWNdkT8r8gg@mail.gmail.com>
In-Reply-To: <CAHc5FiXv=aeKKwpz2RP3ho+d-eggxfGuECk1deyNWNdkT8r8gg@mail.gmail.com>
Content-Type: text/plain;
 charset=koi8-u;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/08/2012 11:28 AM, Mykyta Iziumtsev wrote:
> Add 5GHz band and mark 2.4GHz and 5GHz as NO-OUTDOOR according to
> "Р╕шення про затвердження Перел╕ку рад╕оелектронних засоб╕в
> та випром╕нювальних пристро╖в, для експлуатац╕╖ яких не потр╕бн╕
> дозволи на експлуатац╕ю" from 27 May 2010.
>
> Ref: http://www.ucrf.gov.ua/uk/doc/nkrz/1196068874
>
> Update rules as follows as lowest common denominator:
>          (2400 - 2483.5 @ 40), (N/A, 20), NO-OUTDOOR
>          (5150 - 5350 @ 40), (N/A, 20), NO-OUTDOOR
>
> Signed-off-by: Mykyta Iziumtsev <mykyta.iziumtsev@gmail.com>
> Signed-off-by: Pavel Chernyshev <pchernyshev@gmail.com>
> Signed-off-by: Andrew Bordunov <andrew.bordunov@gmail.com>
> ---
>   db.txt |    3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/db.txt b/db.txt
> index 4c54543..08c6c89 100644
> --- a/db.txt
> +++ b/db.txt
> @@ -653,7 +653,8 @@ country TR: DFS-ETSI
>   	(5250 - 5330 @ 20), (N/A, 20), DFS
>

Some time ago I suggested to add the source ref in the db.txt. Could we 
add that here now:

+ /*
+  * source: http://www.ucrf.gov.ua/uk/doc/nkrz/1196068874
+  */
>   country UA:
> -	(2402 - 2482 @ 40), (N/A, 20)
> +	(2400 - 2483.5 @ 40), (N/A, 20), NO-OUTDOOR
> +	(5150 - 5350 @ 40), (N/A, 20), NO-OUTDOOR
>
>   country US: DFS-FCC
>   	(2402 - 2472 @ 40), (3, 27)
>

Regards,
AvS

