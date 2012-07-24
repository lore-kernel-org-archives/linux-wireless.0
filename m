Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:53579 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753426Ab2GXDrn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Jul 2012 23:47:43 -0400
Received: by obbuo13 with SMTP id uo13so10501656obb.19
        for <linux-wireless@vger.kernel.org>; Mon, 23 Jul 2012 20:47:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAGRGNgX6dzeZKeZhECPniWTGoyOymwA9ZB1X7NmTD7pCtTyacg@mail.gmail.com>
References: <1343092554-17734-1-git-send-email-yeohchunyeow@gmail.com>
	<CAG6hwVNnqTBi10vGsjYqYBOedtaThjyJuRt6o=XpZF_dRaqQsA@mail.gmail.com>
	<CAEFj986CjnbT=j_a7wHvMX9WshjtGD1wttad5iAPM_ViaQhqTg@mail.gmail.com>
	<CAGRGNgX6dzeZKeZhECPniWTGoyOymwA9ZB1X7NmTD7pCtTyacg@mail.gmail.com>
Date: Tue, 24 Jul 2012 11:47:43 +0800
Message-ID: <CAEFj986PT-vNPfk5kdSvTsspgvuvbx2ZMsigd00o0xaaV6nxpQ@mail.gmail.com> (sfid-20120724_054746_217944_FA0160B7)
Subject: Re: [PATCH v3] mac80211: add extra checking for RC init upon
 receiving mesh beacon
From: Yeoh Chun-Yeow <yeohchunyeow@gmail.com>
To: Julian Calaby <julian.calaby@gmail.com>
Cc: devel@lists.open80211s.org, Thomas Pedersen <thomas@cozybit.com>,
	johannes@sipsolutions.net, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi, Julian

> So you could remove it from the if statement and move the one that's
> after the if statement above the if statement and the code would be
> functionally equivalent and cleaner.

Noted. Thanks

Regards,
Chun-Yeow
