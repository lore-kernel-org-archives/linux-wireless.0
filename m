Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f178.google.com ([209.85.223.178]:53343 "EHLO
	mail-iw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752116AbZIWXab (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Sep 2009 19:30:31 -0400
Received: by iwn8 with SMTP id 8so626070iwn.33
        for <linux-wireless@vger.kernel.org>; Wed, 23 Sep 2009 16:30:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1253748426.2931.9.camel@localhost.localdomain>
References: <43e72e890909221001m19f076d8n64fb012b486f666a@mail.gmail.com>
	<1253748426.2931.9.camel@localhost.localdomain>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Wed, 23 Sep 2009 16:30:15 -0700
Message-ID: <43e72e890909231630r7492fe78m23bceb24a629538b@mail.gmail.com>
Subject: Re: Synching trees for BT 3.0 and a possible compat-bluetooth
To: Marcel Holtmann <marcel@holtmann.org>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"Jouni.Malinen" <Jouni.Malinen@atheros.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Gaurav Jauhar <gaurav.jauhar@atheros.com>,
	Senthil Balasubramanian <senthilkumar@atheros.com>,
	Jothikumar Mothilal <jothikumar.mothilal@atheros.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Kevin Hayes <kevin@atheros.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Sep 23, 2009 at 4:27 PM, Marcel Holtmann <marcel@holtmann.org> wrote:
> Hi Luis,
>
>> I forgot to poke about BT 3.0 synching at the summit. To work on
>> bluetooth 3.0 we'll need some synching of trees between
>> wireless-testing and Marcel's bluetooth tree. Also a compat-bluetooth
>> might be in order to accomplish the same as we do with
>> compat-wireless, only it would seem logical to consider tying to just
>> merge this with compat-wireless to get the features required for
>> bluetooth 3.0; to do this having one tree with both would be nice with
>> the added benefit of all the same compat-2.6.3x.[ch] files being
>> reused. Synching of the trees would be required only when a feature on
>> one tree is not yet available on the latest rc kernel (provided marcel
>> rebases on Linus' latest rc as well, not sure), this will probably be
>> important during initial implementation, not sure how much divergence
>> we should expect after this goes through a release through Linus.
>>
>> So any thoughts on synching bluetooth and wireless-testing other than
>> doing so on a private tree for development purposes?
>
> we don't need this right now. For the initial development of the WiFi
> AMP, we will use the fact that you can create HCI RAW devices from a
> driver. These are skipped by BlueZ and only show up in hciconfig. That
> should be enough for testing.

Thanks Marcel, when do you expect we would need this?

  Luis
