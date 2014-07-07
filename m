Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f46.google.com ([74.125.82.46]:54539 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752157AbaGGSo7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Jul 2014 14:44:59 -0400
Received: by mail-wg0-f46.google.com with SMTP id l18so1384650wgh.17
        for <linux-wireless@vger.kernel.org>; Mon, 07 Jul 2014 11:44:58 -0700 (PDT)
Message-ID: <53BAEAA4.1070000@gmail.com> (sfid-20140707_204508_831854_608F56B3)
Date: Mon, 07 Jul 2014 21:44:52 +0300
From: Emmanuel Grumbach <egrumbach@gmail.com>
MIME-Version: 1.0
To: John Linville <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: Re: pull request: iwlwifi-next 2014-07-06
References: <53B917DC.5050902@gmail.com>
In-Reply-To: <53B917DC.5050902@gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="e6Q4sHeqrT01VljSkNsb6153J8BdJkA6K"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--e6Q4sHeqrT01VljSkNsb6153J8BdJkA6K
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable



On 07/06/2014 12:33 PM, Emmanuel Grumbach wrote:
> Hi John,
>=20
> This is a pull request intended for 3.17. Note that I merged wireless-n=
ext because of dependencies on mac80211.
> I also merged iwlwifi-fixes to avoid conflicts.
>=20
> Highlight here is the continuation of CSA by Andrei and Luca and Arik's=
 work on TDLS - both are yet to be continued.
> David has a new firmware API for Scan, and I add a new API for BT Coex.=
 Along with that, the usual amount of work on new devices and fixes.
>=20
> Please pull. Thanks!
>=20
> The following changes since commit 15be8e89cdd999124a2307ffd6dacb895c3b=
802e:
>=20
>   b43: add more bcma cores (2014-07-01 14:29:39 -0400)
>=20
> are available in the git repository at:
>=20
>   git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next.gi=
t for-john
>=20
> for you to fetch changes up to 0620b78632d4d3799d67ae846d30b3f07cba3862=
:
I had to fixup one commit - new HEAD is 589a6ba46bdf9a4a4817fef011ff61905=
a1aa244.

>=20
>   iwlwifi: mvm: minor fix in comment (2014-07-06 12:28:04 +0300)
>=20
> ----------------------------------------------------------------
> Andrei Otcheretianski (4):
>       iwlwifi: mvm: Use beacon_get_template instead of beacon_get
>       iwlwifi: mvm: Protect mvm->csa_vif with RCU
>       iwlwifi: mvm: Reflect GO channel switch in NoA
>       iwlwifi: mvm: Use CS tx block bit for AP/GO
>=20
> Arik Nemtsov (5):
>       Revert "iwlwifi: remove IWL_UCODE_TLV_FLAGS_UAPSD_SUPPORT flag"
>       iwlwifi: mvm: disallow new TDLS stations when appropriate
>       iwlwifi: mvm: protect TDLS discovery session
>       iwlwifi: disable PSM on vifs with associated TDLS peers
>       iwlwifi: mvm: teardown TDLS peers when initiating DCM
>=20
> David Spinadel (3):
>       iwlwifi: mvm: add unified LMAC scan API
>       iwlwifi: mvm: init lmac scan command
>       iwlwifi: mvm: fix endianity in scan command
>=20
> Eliad Peller (2):
>       iwlwifi: mvm: rs: don't clear persistent fields
>       iwlwifi: mvm: rs: don't save debugfs files
>=20
> Emmanuel Grumbach (21):
>       iwlwifi: dvm: don't enable CTS to self
>       iwlwifi: mvm: disable CTS to Self
>       Merge remote-tracking branch 'iwlwifi-fixes/master' into iwlwifi-=
next
>       Merge remote-tracking branch 'wireless-next/master' into iwlwifi-=
next
>       iwlwifi: fix naming mistake for the fw_monitor module parameter
>       iwlwifi: remove wrong comment about alignment in iwl-fw-error-dum=
p.h
>       iwlwifi: mvm: don't collect logs in the interrupt thread
>       iwlwifi: mvm: kill iwl_mvm_fw_error_rxf_dump
>       iwlwifi: mvm: update layout of firmware error dump
>       iwlwifi: rename iwl_fw_error_fw_mon to iwl_fw_error_dump_fw_mon
>       iwlwifi: mvm: remove unused flags from TX command
>       iwlwifi: mvm: BT Coex - prepare towards new API
>       iwlwifi: mvm: BT Coex - new API
>       iwlwifi: mvm: BT Coex - convert the sw boost update to new API
>       iwlwifi: mvm: BT Coex - convert the co-running update to new API
>       iwlwifi: mvm: BT Coex - convert reduced Tx power to new API
>       iwlwifi: mvm: BT Coex - add High Band retention
>       iwlwifi: mvm: BT Coex - fix debugfs with old API
>       iwlwifi: mvm: BT Coex - fix the ACK / CTS kill mask
>       iwlwifi: mvm: BT Coex - relax constraints when TTC / RRC is activ=
e
>       iwlwifi: mvm: minor fix in comment
>=20
> Eran Harary (3):
>       iwlwifi: mvm: read the mac address in family 8000
>       iwlwifi: mvm: warn about empty OTP
>       iwlwifi: 8000: drop a print when the address is invalid
>=20
> Gregory Greenman (1):
>       iwlwifi: mvm: wait for d0i3 exit in add interface flow
>=20
> Ilan Peer (1):
>       iwlwifi: mvm: Fix broadcast filtering
>=20
> Johannes Berg (4):
>       iwlwifi: mvm: don't send zero quota to the firmware
>       iwlwifi: mvm: validate that we don't send zero quota
>       iwlwifi: mvm: don't pass update type to quota iterator
>       iwlwifi: mvm: remove update type argument from quota update
>=20
> Liad Kaufman (1):
>       iwlwifi: mvm: remove 8000 HW family setting of adc sampling on ni=
c config
>=20
> Luciano Coelho (3):
>       iwlwifi: mvm: let iwl_mvm_update_quotas disregard a disabled vif
>       iwlwifi: mvm: add switch_vif_chanctx operation
>       iwlwifi: mvm: CSA unbind-bind flow support for client
>=20
> Oren Givon (1):
>       iwlwifi: update the 7265 series HW IDs
>=20
>  drivers/net/wireless/iwlwifi/dvm/rxon.c          |   12 -
>  drivers/net/wireless/iwlwifi/iwl-drv.c           |    2 +-
>  drivers/net/wireless/iwlwifi/iwl-fw-error-dump.h |    8 +-
>  drivers/net/wireless/iwlwifi/iwl-fw.h            |    5 +
>  drivers/net/wireless/iwlwifi/iwl-nvm-parse.c     |   63 ++++-
>  drivers/net/wireless/iwlwifi/mvm/Makefile        |    2 +-
>  drivers/net/wireless/iwlwifi/mvm/coex.c          |  442 ++++++++++++++=
---------------------
>  drivers/net/wireless/iwlwifi/mvm/coex_legacy.c   | 1260 ++++++++++++++=
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++=
++++++++++++
>  drivers/net/wireless/iwlwifi/mvm/debugfs.c       |  202 ++++++++++++--=
--
>  drivers/net/wireless/iwlwifi/mvm/fw-api-coex.h   |  230 ++++++++++++++=
----
>  drivers/net/wireless/iwlwifi/mvm/fw-api-scan.h   |  209 ++++++++++++++=
++-
>  drivers/net/wireless/iwlwifi/mvm/fw-api-tx.h     |   16 +-
>  drivers/net/wireless/iwlwifi/mvm/fw-api.h        |   11 +-
>  drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c      |   71 +++++-
>  drivers/net/wireless/iwlwifi/mvm/mac80211.c      |  495 ++++++++++++++=
++++++++++++++++++++-----
>  drivers/net/wireless/iwlwifi/mvm/mvm.h           |   95 ++++++--
>  drivers/net/wireless/iwlwifi/mvm/nvm.c           |    2 +
>  drivers/net/wireless/iwlwifi/mvm/ops.c           |  133 +++--------
>  drivers/net/wireless/iwlwifi/mvm/phy-ctxt.c      |   26 +++
>  drivers/net/wireless/iwlwifi/mvm/power.c         |   39 ++--
>  drivers/net/wireless/iwlwifi/mvm/quota.c         |   38 +--
>  drivers/net/wireless/iwlwifi/mvm/rs.c            |   96 ++++----
>  drivers/net/wireless/iwlwifi/mvm/rs.h            |   19 +-
>  drivers/net/wireless/iwlwifi/mvm/rx.c            |   17 ++
>  drivers/net/wireless/iwlwifi/mvm/scan.c          |  457 ++++++++++++++=
+++++++++++++++++-----
>  drivers/net/wireless/iwlwifi/mvm/sta.c           |   54 +++++
>  drivers/net/wireless/iwlwifi/mvm/sta.h           |   10 +
>  drivers/net/wireless/iwlwifi/mvm/time-event.c    |   73 ++++++
>  drivers/net/wireless/iwlwifi/mvm/time-event.h    |   29 +++
>  drivers/net/wireless/iwlwifi/mvm/tx.c            |   17 +-
>  drivers/net/wireless/iwlwifi/mvm/utils.c         |   65 ------
>  drivers/net/wireless/iwlwifi/pcie/drv.c          |    3 +-
>  drivers/net/wireless/iwlwifi/pcie/trans.c        |    4 +-
>  33 files changed, 3375 insertions(+), 830 deletions(-)
>  create mode 100644 drivers/net/wireless/iwlwifi/mvm/coex_legacy.c
>=20


--e6Q4sHeqrT01VljSkNsb6153J8BdJkA6K
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJTuuqlAAoJEC0Llv5uNjIBZiIQAIVzli6+0yogqhadkaHYaZTK
rCT+YssspkxORE8G6nqc0x/1nlSoXYslL6fHUEsfYN/nYzBtE9QRRwUFANVgQlae
3YYmV3XUE9L/vIE73MZcpNJDNw3FX7VQ+2vtoBTNSl8a3oUrTuPDNjFVbHm+e+Mw
Sz+RXE/lg+mPhw7EJFbmK/r6gWuA3SNu3Bagc9gwH08Xorj9JKGcJa9Kp2NL2ejI
im/D1/GObW5xEX3B7Obmioz2hpTIClnJ+uFClTirmxRaL/t9PKE8wtXUhMM06clT
Ddi+Pf4Fnv94o7eBrc6mWO5GN6rsjE1Ed8aYeLv1GEvl6DcDU6EY2fhntVTrFcTs
rJEIP8El2HjFivaoLaPkJWRlXiG1ZoqQRXYgkwPCN8+DFWO3BTxxb4nibTl9Qm0/
wC7q8Ib8XZBgpE0KNiwgdaSZ0eK+hCoH+WOnhFazn7tmeFgMOudVoDR7/9UamBXV
wiZy0LOFAUhPiasI+kqvz1B/gqGHT5wBF6KOyIeXYnmEVslFgg5b3dK9P42tn8UZ
kE7DbnBC+r4ieVGpGFEzfxXAop862GMTXdJrg/H1ZhDbLjDG9q8YqGEbAFC7oSxD
BckV4z0Bj1YQ+KS1zYFd9rmpQUgGrRUiV2NbW/LUPbb2UZahH1T6Msu3uWEskd8U
cZrjV79ifY467sxkQME4
=wI74
-----END PGP SIGNATURE-----

--e6Q4sHeqrT01VljSkNsb6153J8BdJkA6K--
