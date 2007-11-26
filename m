Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:36295 "EHLO
	annwn14.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751261AbXKZShb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Nov 2007 13:37:31 -0500
From: Michael Wu <flamingice@sourmilk.net>
To: Ron Rindjunsky <ron.rindjunsky@intel.com>
Subject: Re: [PATCH 06/15] mac80211: adding 802.11n essential A-MSDU Rx capability
Date: Mon, 26 Nov 2007 13:40:50 -0500
Cc: linville@tuxdriver.com, johannes@sipsolutions.net,
	linux-wireless@vger.kernel.org, tomas.winkler@intel.com
References: <11960864823402-git-send-email-ron.rindjunsky@intel.com> <119608649124-git-send-email-ron.rindjunsky@intel.com>
In-Reply-To: <119608649124-git-send-email-ron.rindjunsky@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart3226708.Hl9iMq48ie";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200711261340.54406.flamingice@sourmilk.net> (sfid-20071126_183738_474726_3DFE263B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart3226708.Hl9iMq48ie
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Monday 26 November 2007 09:14:33 Ron Rindjunsky wrote:
> diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
> index 9caf124..247af42 100644
> --- a/net/mac80211/ieee80211_i.h
> +++ b/net/mac80211/ieee80211_i.h
> @@ -155,6 +155,7 @@ struct ieee80211_txrx_data {
>  			int load;
>  			u32 tkip_iv32;
>  			u16 tkip_iv16;
> +			u8  amsdu_frame;
A flag would be preferable.

-Michael Wu

--nextPart3226708.Hl9iMq48ie
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.4-svn0 (GNU/Linux)

iD8DBQBHSxM2T3Oqt9AH4aERAkQBAJ90uFa2vwACsU3zaDSAes9FwMOCUQCgvbEW
TJEOTpbALjOqA9BCoownSRE=
=Anl2
-----END PGP SIGNATURE-----

--nextPart3226708.Hl9iMq48ie--
