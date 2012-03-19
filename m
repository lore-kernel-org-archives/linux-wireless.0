Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:41956 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758370Ab2CSXCN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Mar 2012 19:02:13 -0400
Received: by eekc41 with SMTP id c41so2875600eek.19
        for <linux-wireless@vger.kernel.org>; Mon, 19 Mar 2012 16:02:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CA++WF2PCO8ZdhfSMs6_gy2gz5OvTkVrGYXm0X6Aicoe5JmK+pg@mail.gmail.com>
References: <CAG-2HqUqwHo_xgqC79riQF2DA4DPz1Qy5ZARQK8GT+tf_-UKRg@mail.gmail.com>
 <20120130184446.GB2493@tuxdriver.com> <CA++WF2PnEzS5CAfryaPrJSs3Xb3s0WK1zR7N5o8+ud2HiU5GCw@mail.gmail.com>
 <20120315110219.GA2335@redhat.com> <CA++WF2P8E=0Xym92MuU84RwaP5Y9uyCyqw5jefh25QDz-Cpzkw@mail.gmail.com>
 <20120317143640.GC23594@khazad-dum.debian.net> <CA++WF2PCO8ZdhfSMs6_gy2gz5OvTkVrGYXm0X6Aicoe5JmK+pg@mail.gmail.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Tue, 20 Mar 2012 10:01:51 +1100
Message-ID: <CAGRGNgXmx9_uDETd7MOJc4hXYXTMd1CSymevKh4DA4uSvjK=0Q@mail.gmail.com> (sfid-20120320_000216_963010_250BBEEA)
Subject: Re: MAINTAINER NEEDED -- Re: status of ipw2x00
To: Stanislav Yakovlev <stas.yakovlev@gmail.com>
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
	Stanislaw Gruszka <sgruszka@redhat.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Tom Gundersen <teg@jklm.no>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	linux-wireless@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Stanislav,

On Tue, Mar 20, 2012 at 09:56, Stanislav Yakovlev
<stas.yakovlev@gmail.com> wrote:
> Hello Henrique,
>
> On 17 March 2012 07:36, Henrique de Moraes Holschuh <hmh@hmh.eng.br> wrote:
>> Chances are ipw2xxx firmware will never get a new revision anyway, so
>> reloading the modules is not too large a price to pay if the user does
>> decide he has to force a firmware refresh...
>
> As far as I know there is no way to force firmware refresh at the
> moment without reloading the driver. If you know any implementations
> of such behavior, please let me know.

>From what I understand, this usually happens when something goes
horribly wrong and the only solution is to re-start the card from
scratch.

Reloading a module to do that isn't such a bad thing, but it would
arguably be better if it happened automatically. I believe that this
is one of the reset options for modern Intel cards.

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/
