Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f180.google.com ([209.85.222.180]:45739 "EHLO
	mail-pz0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751438AbZGVOL7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Jul 2009 10:11:59 -0400
Received: by pzk10 with SMTP id 10so44769pzk.33
        for <linux-wireless@vger.kernel.org>; Wed, 22 Jul 2009 07:11:59 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20090722131957.GA5276@tuxdriver.com>
References: <f7de31c0907220607v3266710co5640389fc0ccbc22@mail.gmail.com>
	 <20090722131957.GA5276@tuxdriver.com>
Date: Wed, 22 Jul 2009 21:04:10 +0700
Message-ID: <f7de31c0907220704x5000854bq652b09bf5b6bfc3c@mail.gmail.com>
Subject: Re: Update for regulatory database on 5GHz band for Thailand (TH)
From: Phattanon Duangdara <sfalpha@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jul 22, 2009 at 8:19 PM, John W. Linville<linville@tuxdriver.com> wrote:
> On Wed, Jul 22, 2009 at 08:07:21PM +0700, Phattanon Duangdara wrote:
>> National Telecommunication Commisions of Thailand has announce new
>> regulatory about 5GHz for RLAN last year.
>>
>> But I found that Linux Wireless Regulatory Database not get updated.
>>
>> Reference in Thai Language:
>> http://www.ratchakitcha.soc.go.th/DATA/PDF/2551/E/042/64.PDF
>> (Partly in english and reference to ITU/FCC documents, I think it
>> quite easy to understand)
>>
>> How can this get update on Regulatory Database ?
>
> What a beautiful font! :-)
>
> While there is enough English/numbers there that I can probably judge
> what it means, I'd feel a lot better if someone else (perhaps you)
> submitted a patch against the tree here:
>
>        git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-regdb.git
>
> Thanks!
>
> John
> --
> John W. Linville                Someday the world will need a hero, and you
> linville@tuxdriver.com                  might be all we have.  Be ready.
>                        –iva Honduras Libre!
>

Actually, NTC provide english translated documents, but for thism, it
missing from their website. I already contact NTC to get those
document in english for reference and clarification. Later models of
some Laptops sell in Thailand already has 5GHz enabled radio.

For now I will try to update db against tree from my knowledge.

Phattanon
